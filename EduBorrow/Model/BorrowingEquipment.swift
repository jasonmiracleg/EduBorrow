//
//  BorrowingEquipment.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftData
import Foundation

@Model
class BorrowingEquipment: Identifiable {
    
    @Attribute(.unique)
    var borrowingEquipmentId: UUID
    
    @Relationship(inverse: \Borrowing.borrowedEquipments)
    var borrowing: Borrowing

    @Relationship(inverse: \Equipment.borrowingRecords)
    var equipment: Equipment
    
    var quantity: Int
    
    init(borrowing: Borrowing, equipment: Equipment, quantity: Int) {
        self.borrowingEquipmentId = UUID()
        self.borrowing = borrowing
        self.equipment = equipment
        self.quantity = quantity
    }
}
