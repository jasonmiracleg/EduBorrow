//
//  BorrowingService.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import Foundation
import SwiftData

final class BorrowingService {

    enum CreateError: Error {
        case pastDate
        case invalidDuration
        case emptyPurpose
        case noEquipmentSelected
        case insufficientStock(equipmentName: String)
    }

    // MARK: - CREATE
    func createBorrowRequest(
        user: User,
        room: Room,
        usageDate: Date,
        duration: Int,
        purpose: String,
        selectedEquipments: [Equipment: Int],
        context: ModelContextType
    ) throws {

        // Basic temporal validation
        guard usageDate >= Date() else {
            throw CreateError.pastDate
        }

        // Duration must be positive
        guard duration > 0 else {
            throw CreateError.invalidDuration
        }

        // Purpose must not be empty
        if purpose.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw CreateError.emptyPurpose
        }

        // Filter selected equipments with positive quantities
        let filteredEquipments = selectedEquipments.filter { $0.value > 0 }

        guard !filteredEquipments.isEmpty else {
            throw CreateError.noEquipmentSelected
        }

        // Validate stock availability at creation time
        for (equipment, quantity) in filteredEquipments {
            if equipment.stock < quantity {
                throw CreateError.insufficientStock(equipmentName: equipment.equipmentName)
            }
        }

        let borrowing = Borrowing(
            user: user,
            room: room,
            requestDate: Date(),
            usageDate: usageDate,
            duration: duration,
            statusApproval: .pending,
            purpose: purpose
        )

        context.insert(borrowing)

        for (equipment, quantity) in filteredEquipments {
            let item = BorrowingEquipment(
                borrowing: borrowing,
                equipment: equipment,
                quantity: quantity
            )
            borrowing.borrowedEquipments.append(item)
            context.insert(item)
        }

        save(context)
    }

    // MARK: - APPROVE (ALL RULES HERE)
    func approveBorrowing(_ borrowing: Borrowing, context: ModelContextType) -> Bool {

        guard borrowing.statusApproval == .pending else {
            lastApprovalError = .alreadyProcessed
            return false
        }

        // RULE 1: Room availability
        guard isRoomAvailable(borrowing, context: context) else {
            print("Room not available")
            lastApprovalError = .roomNotAvailable
            return false
        }

        // RULE 2 & 5: Stock validation
        guard isStockAvailable(borrowing) else {
            print("Insufficient stock")
            lastApprovalError = .insufficientStock
            return false
        }

        // APPLY APPROVAL
        borrowing.statusApproval = .approved

        // RULE 3: Deduct stock
        reduceStock(for: borrowing)

        save(context)

        lastApprovalError = nil
        return true
    }

    enum ApprovalError: String {
        case alreadyProcessed
        case roomNotAvailable
        case insufficientStock
    }

    private(set) var lastApprovalError: ApprovalError?


    // MARK: - REJECT
    func rejectBorrowing(_ borrowing: Borrowing, context: ModelContextType) -> Bool {

        guard borrowing.statusApproval == .pending else {
            lastApprovalError = .alreadyProcessed
            return false
        }

        borrowing.statusApproval = .rejected
        save(context)

        lastApprovalError = nil
        return true
    }

    // MARK: - FINALIZE EXPIRED
    func finalizeExpiredBorrowings(context: ModelContextType) {

        let all = fetchAllBorrowings(context: context)
        let now = Date()

        for borrowing in all where borrowing.statusApproval == .approved {

            let endTime = borrowing.usageDate
                .addingTimeInterval(TimeInterval(borrowing.durationInHours * 3600))

            if endTime < now {
                borrowing.statusApproval = .finished

                borrowing.returnTime = now

                restoreStock(for: borrowing)
            }
        }

        save(context)
    }

    // MARK: - ROOM AVAILABILITY CHECK
    private func isRoomAvailable(_ borrowing: Borrowing, context: ModelContextType) -> Bool {
        let all = fetchAllBorrowings(context: context)

        return !all.contains {
            $0.room.roomId == borrowing.room.roomId &&
            $0.statusApproval == .approved &&
            isOverlapping($0, borrowing)
        }
    }

    private func isOverlapping(_ a: Borrowing, _ b: Borrowing) -> Bool {
        let aEnd = a.usageDate.addingTimeInterval(Double(a.durationInHours * 3600))
        let bEnd = b.usageDate.addingTimeInterval(Double(b.durationInHours * 3600))

        return a.usageDate < bEnd && b.usageDate < aEnd
    }

    // MARK: - STOCK CHECK
    private func isStockAvailable(_ borrowing: Borrowing) -> Bool {
        for item in borrowing.borrowedEquipments {
            if item.equipment.stock < item.quantity {
                return false
            }
        }
        return true
    }

    // MARK: - STOCK UPDATE
    private func reduceStock(for borrowing: Borrowing) {
        for item in borrowing.borrowedEquipments {
            item.equipment.stock -= item.quantity
        }
    }

    private func restoreStock(for borrowing: Borrowing) {
        for item in borrowing.borrowedEquipments {
            item.equipment.stock += item.quantity
        }
    }

    // MARK: - READ
    func fetchAllBorrowings(context: ModelContextType) -> [Borrowing] {
        (try? context.fetch(FetchDescriptor<Borrowing>())) ?? []
    }

    func fetchPendingBorrowings(user: User, context: ModelContextType) -> [Borrowing] {
        fetchAllBorrowings(context: context).filter {
            $0.user.userId == user.userId && $0.statusApproval == .pending
        }
    }

    // MARK: - DELETE
    func deleteBorrowing(_ borrowing: Borrowing, context: ModelContextType) {
        context.delete(borrowing)
        save(context)
    }

    // MARK: - SAVE
    private func save(_ context: ModelContextType) {
        do {
            try context.save()
        } catch {
            print("Save Error: \(error)")
        }
    }
    
    // MARK: - Update
    func updateBorrowing(
        borrowing: Borrowing,
        room: Room,
        usageDate: Date,
        duration: Int,
        purpose: String,
        selectedEquipments: [Equipment: Int],
        context: ModelContextType
    ) {

        guard borrowing.statusApproval == .pending else {
            print("Cannot edit non-pending borrowing")
            return
        }

        borrowing.room = room
        borrowing.usageDate = usageDate
        borrowing.durationInHours = duration
        borrowing.purpose = purpose

        // reset equipments
        borrowing.borrowedEquipments.removeAll()

        for (equipment, quantity) in selectedEquipments where quantity > 0 {
            let item = BorrowingEquipment(
                borrowing: borrowing,
                equipment: equipment,
                quantity: quantity
            )
            borrowing.borrowedEquipments.append(item)
        }

        save(context)
    }
    
    func autoRejectExpiredRequests(context: ModelContextType) {

        let all = fetchAllBorrowings(context: context)
        let now = Date()

        for borrowing in all where borrowing.statusApproval == .pending {

            if borrowing.usageDate < now {
                borrowing.statusApproval = .rejected
            }
        }

        save(context)
    }
    
    func finishBorrowing(_ borrowing: Borrowing, context: ModelContextType) {

        guard borrowing.statusApproval == .approved else {
            print("Only approved borrowings can be finished")
            return
        }

        borrowing.statusApproval = .finished

        save(context)
    }
}
