//
//  Borrowing.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftData
import Foundation

@Model
class Borrowing: Identifiable {
    
    @Attribute(.unique)
    var borrowingId: UUID
    
    @Relationship(inverse: \User.borrowings)
    var user: User
    
    @Relationship(inverse: \Room.borrowings)
    var room: Room
    
    @Relationship(deleteRule: .cascade)
    var borrowedEquipments: [BorrowingEquipment] = []
    
    var requestDate: Date
    var usageDate: Date
    var durationInHours: Int
    var statusApproval: Approval
    var purpose: String
    var returnTime: Date?
    
    init(user: User, room: Room, requestDate: Date, usageDate: Date, duration: Int, statusApproval: Approval, purpose: String, returnTime: Date? = nil) {
        self.borrowingId = UUID()
        self.user = user
        self.room = room
        self.requestDate = requestDate
        self.usageDate = usageDate
        self.durationInHours = duration
        self.statusApproval = statusApproval
        self.purpose = purpose
        self.returnTime = returnTime
    }
}

extension Borrowing {
    var equipmentList: [String] {
        borrowedEquipments.map {
            "\($0.equipment.equipmentName) x\($0.quantity)"
        }
    }
}
