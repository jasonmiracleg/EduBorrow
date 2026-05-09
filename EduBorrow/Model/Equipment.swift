//
//  Equipment.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import Foundation
import SwiftData

@Model
class Equipment: Identifiable {
    
    @Attribute(.unique)
    var equipmentId: String
    
    var equipmentName: String
    var stock: Int
    var category: Category
    
    var id: String { equipmentId }
    
    @Relationship(deleteRule: .cascade)
    var borrowingRecords: [BorrowingEquipment] = []
    
    init(equipmentId: String, equipmentName: String, stock: Int, category: Category) {
        self.equipmentId = equipmentId
        self.equipmentName = equipmentName
        self.stock = stock
        self.category = category
    }
}
