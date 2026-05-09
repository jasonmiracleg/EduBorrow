//
//  Room.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import Foundation
import SwiftData

@Model
class Room: Identifiable {
    
    @Attribute(.unique)
    var roomId: UUID
    
    @Relationship(deleteRule: .cascade)
    var borrowings: [Borrowing] = []
    
    var floor: String
    var building: String
    var capacity: Int
    var isAvailable: Bool
    
    init(floor: String, building: String, capacity: Int) {
        self.roomId = UUID()
        self.floor = floor
        self.building = building
        self.capacity = capacity
        self.isAvailable = true
    }
}
