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

    @Published var pendingBorrowings: [Borrowing] = []
    @Published var selectedBorrowing: Borrowing?
    @Published var showUpdateSheet: Bool = false

    private let service = BorrowingService()

    var recentPendingBorrowings: [Borrowing] {
        pendingBorrowings
            .sorted { $0.requestDate > $1.requestDate }
            .prefix(3)
            .map { $0 }
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

        // IMPORTANT: refresh UI after insert
        fetchPendingRequests(user: user, context: context)
    }

    // MARK: - READ (PENDING)
    func fetchPendingRequests(
        user: User,
        context: ModelContext
    ) {

        let results = service.fetchPendingBorrowings(
            user: user,
            context: context
        )

        self.pendingBorrowings = results
    }

    // MARK: - READ (ALL - optional helper)
    func fetchAllBorrowings(context: ModelContext) {

        let results = service.fetchAllBorrowings(context: context)

        self.pendingBorrowings = results
    }

    // MARK: - UPDATE STATUS
    func updateStatus(
        borrowing: Borrowing,
        newStatus: Approval,
        user: User,
        context: ModelContext
    ) {

        service.updateBorrowingStatus(
            borrowing: borrowing,
            newStatus: newStatus,
            context: context
        )

        fetchPendingRequests(user: user, context: context)
    }

    // MARK: - UPDATE BORROWING
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

    // MARK: - DELETE
    func deleteBorrowing(
        borrowing: Borrowing,
        user: User,
        context: ModelContext
    ) {

        service.deleteBorrowing(
            borrowing: borrowing,
            context: context
        )

        fetchPendingRequests(user: user, context: context)
    }
}
