//
//  UserService.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftData
import Foundation

final class UserService {

    func fetchUsers(context: ModelContext) -> [User] {
        let descriptor = FetchDescriptor<User>(sortBy: [SortDescriptor(\.name)])
        return (try? context.fetch(descriptor)) ?? []
    }

    func addUser(
        identityNumber: String,
        name: String,
        phoneNumber: String,
        role: Role,
        context: ModelContext
    ) {
        let password = name + "123"

        let newUser = User(
            identityNumber: identityNumber,
            name: name,
            phoneNumber: phoneNumber,
            password: password,
            role: role
        )

        context.insert(newUser)
    }

    func updateUser(
            user: User,
            identityNumber: String,
            name: String,
            phoneNumber: String,
            role: Role,
            context: ModelContext
        ) {
            user.identityNumber = identityNumber
            user.name = name
            user.phoneNumber = phoneNumber
            user.role = role

            try? context.save()
        }

    func deleteUser(user: User, context: ModelContext) {
        context.delete(user)
    }
}
