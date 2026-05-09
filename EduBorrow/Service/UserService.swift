//
//  UserService.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftData
import Foundation

final class UserService {

    func fetchUsers(context: ModelContextType) -> [User] {
        let descriptor = FetchDescriptor<User>(sortBy: [SortDescriptor(\.name)])
        return (try? context.fetch(descriptor)) ?? []
    }

    func addUser(
        identityNumber: String,
        name: String,
        phoneNumber: String,
        role: Role,
        context: ModelContextType
    ) {
        let firstWord = name.split(separator: " ").first ?? ""
        let password = firstWord + "123"

        let newUser = User(
            identityNumber: identityNumber,
            name: name,
            phoneNumber: phoneNumber,
            password: String(password),
            role: role
        )

        context.insert(newUser)
        // persist immediately for consistency with other services
        try? context.save()
    }

    func updateUser(
            user: User,
            identityNumber: String,
            name: String,
            phoneNumber: String,
            role: Role,
            context: ModelContextType
        ) {
            user.identityNumber = identityNumber
            user.name = name
            user.phoneNumber = phoneNumber
            user.role = role

            try? context.save()
        }

    func deleteUser(user: User, context: ModelContextType) {
        context.delete(user)
        try? context.save()
    }
}
