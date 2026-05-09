//
//  BorrowingService.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import Foundation
import SwiftData

final class BorrowingService {

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

        do {
            try context.save()
        } catch {
            print("Save Error: \(error)")
        }
    }
}
