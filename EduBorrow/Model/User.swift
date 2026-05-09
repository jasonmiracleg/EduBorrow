//
//  User.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftData
import Foundation
import CryptoKit

@Model
class User: Identifiable {
    
    @Attribute(.unique)
    var userId: UUID
    
    @Relationship(deleteRule: .cascade)
    var borrowings: [Borrowing] = []
    
    var identityNumber: String
    var name: String
    var phoneNumber: String
    var passwordHash: String
    var role: Role
    
    init(
        identityNumber: String,
        name: String,
        phoneNumber: String,
        password: String,
        role: Role
    ) {
        self.userId = UUID()
        self.identityNumber = identityNumber
        self.name = name
        self.phoneNumber = phoneNumber
        self.passwordHash = User.hashPassword(password)
        self.role = role
    }
    
    static func hashPassword(_ password: String) -> String {
        let inputData = Data(password.utf8)
        let hashed = SHA256.hash(data: inputData)
        
        return hashed.compactMap {
            String(format: "%02x", $0)
        }.joined()
    }
}
