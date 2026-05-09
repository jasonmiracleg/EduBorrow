//
//  BorrowingService.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import Foundation
import SwiftData

final class BorrowingService {

    // MARK: - CREATE
    func createBorrowRequest(
        user: User,
        room: Room,
        usageDate: Date,
        duration: Int,
        purpose: String,
        selectedEquipments: [Equipment: Int],
        context: ModelContext
    ) {

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

        for (equipment, quantity) in selectedEquipments {
            guard quantity > 0 else { continue }

            let borrowingEquipment = BorrowingEquipment(
                borrowing: borrowing,
                equipment: equipment,
                quantity: quantity
            )

            borrowing.borrowedEquipments.append(borrowingEquipment)
            context.insert(borrowingEquipment)
        }

        save(context)
    }

    // MARK: - READ (ALL)
    func fetchAllBorrowings(context: ModelContext) -> [Borrowing] {
        do {
            let descriptor = FetchDescriptor<Borrowing>()
            return try context.fetch(descriptor)
        } catch {
            print("Fetch All Error: \(error)")
            return []
        }
    }

    // MARK: - READ (BY USER)
    func fetchBorrowingsByUser(user: User, context: ModelContext) -> [Borrowing]
    {
        do {
            let descriptor = FetchDescriptor<Borrowing>()
            let results = try context.fetch(descriptor)

            return results.filter { $0.user.userId == user.userId }

        } catch {
            print("Fetch By User Error: \(error)")
            return []
        }
    }

    // MARK: - READ (PENDING)
    func fetchPendingBorrowings(user: User, context: ModelContext)
        -> [Borrowing]
    {
        do {
            let descriptor = FetchDescriptor<Borrowing>()
            let results = try context.fetch(descriptor)

            return results.filter {
                $0.user.userId == user.userId && $0.statusApproval == .pending
            }

        } catch {
            print("Fetch Pending Error: \(error)")
            return []
        }
    }

    // MARK: - UPDATE (STATUS)
    func updateBorrowingStatus(
        borrowing: Borrowing,
        newStatus: Approval,
        context: ModelContext
    ) {
        borrowing.statusApproval = newStatus
        save(context)
    }

    // MARK: - UPDATE (GENERAL FIELDS)
    func updateBorrowing(
        borrowing: Borrowing,
        room: Room,
        usageDate: Date,
        duration: Int,
        purpose: String,
        selectedEquipments: [Equipment: Int],
        context: ModelContext
    ) {
        borrowing.room = room
        borrowing.usageDate = usageDate
        borrowing.durationInHours = duration
        borrowing.purpose = purpose

        borrowing.borrowedEquipments.removeAll()

        for (equipment, quantity) in selectedEquipments where quantity > 0 {
            let newItem = BorrowingEquipment(
                borrowing: borrowing,
                equipment: equipment,
                quantity: Int(quantity)
            )
            borrowing.borrowedEquipments.append(newItem)
        }

        save(context)
    }

    // MARK: - DELETE
    func deleteBorrowing(
        borrowing: Borrowing,
        context: ModelContext
    ) {
        context.delete(borrowing)
        save(context)
    }

    // MARK: - SAVE HELPER
    private func save(_ context: ModelContext) {
        do {
            try context.save()
        } catch {
            print("Save Error: \(error)")
        }
    }
}
