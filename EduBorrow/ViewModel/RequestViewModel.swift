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

    private let service = BorrowingService()

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
    }

    func fetchPendingRequests(
        user: User,
        context: ModelContext
    ) {

        do {

            let descriptor = FetchDescriptor<Borrowing>()

            let borrowings = try context.fetch(descriptor)

            pendingBorrowings = borrowings.filter {
                $0.user.userId == user.userId &&
                $0.statusApproval == .pending
            }

        } catch {
            print("Fetch Error: \(error)")
        }
    }
}
