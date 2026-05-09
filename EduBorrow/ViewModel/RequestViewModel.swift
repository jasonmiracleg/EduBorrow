//
//  RequestViewModel.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import Combine
import Foundation
import SwiftData

@MainActor
final class RequestViewModel: ObservableObject {

    private let service = BorrowingService()

    @Published private(set) var borrowings: [Borrowing] = []

    var pendingBorrowings: [Borrowing] {
        borrowings.filter { $0.statusApproval == .pending }
    }

    var recentPendingBorrowings: [Borrowing] {
        Array(pendingBorrowings
            .sorted { $0.requestDate > $1.requestDate }
            .prefix(3))
    }

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
        service.createBorrowRequest(
            user: user,
            room: room,
            usageDate: usageDate,
            duration: duration,
            purpose: purpose,
            selectedEquipments: selectedEquipments,
            context: context
        )

        fetchAllBorrowings(context: context)
    }

    // MARK: - READ
    func fetchAllBorrowings(context: ModelContext) {
        borrowings = service.fetchAllBorrowings(context: context)
    }

    // MARK: - APPROVE (NEW SAFE ENTRY POINT)
    func approve(
        borrowing: Borrowing,
        context: ModelContext
    ) {
        service.approveBorrowing(borrowing, context: context)
    }

    // MARK: - REJECT (NEW SAFE ENTRY POINT)
    func reject(
        borrowing: Borrowing,
        context: ModelContext
    ) {
        service.rejectBorrowing(borrowing, context: context)
    }

    // MARK: - DELETE
    func deleteBorrowing(
        borrowing: Borrowing,
        user: User,
        context: ModelContext
    ) {
        service.deleteBorrowing(borrowing, context: context)
        fetchAllBorrowings(context: context)
    }

    // MARK: - SYNC (optional future hook)
    func sync(user: User, context: ModelContext) {
        service.finalizeExpiredBorrowings(context: context)
        service.autoRejectExpiredRequests(context: context)
        fetchAllBorrowings(context: context)
    }
    
    // MARK: - Update
    func updateBorrowing(
        borrowing: Borrowing,
        room: Room,
        usageDate: Date,
        duration: Int,
        purpose: String,
        selectedEquipments: [Equipment: Int],
        context: ModelContext
    ) {
        
        service.updateBorrowing(
            borrowing: borrowing,
            room: room,
            usageDate: usageDate,
            duration: duration,
            purpose: purpose,
            selectedEquipments: selectedEquipments,
            context: context
        )
    }
}
