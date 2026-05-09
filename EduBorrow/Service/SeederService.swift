//
//  SeederService.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftData
import Foundation

class SeederService {
    static func seedUsers(context: ModelContext) {

        let descriptor = FetchDescriptor<User>()

        do {

            let existingUsers = try context.fetch(descriptor)

            // Prevent duplicate seeding
            if !existingUsers.isEmpty {
                return
            }

            let admin = User(
                identityNumber: "12345678",
                name: "Admin User",
                phoneNumber: "08123456789",
                password: "Admin123",
                role: .admin
            )

            let student = User(
                identityNumber: "0706012210013",
                name: "Jason",
                phoneNumber: "081332162952",
                password: "Student123",
                role: .student
            )
            
            let lecture = User(
                identityNumber: "0987654321",
                name: "Jason",
                phoneNumber: "0129917282",
                password: "Lecture123",
                role: .lecturer
            )

            context.insert(admin)
            context.insert(student)
            context.insert(lecture)

            try context.save()

            print("Dummy users inserted.")

        } catch {

            print("Seeder Error: \(error)")
        }
    }
}
