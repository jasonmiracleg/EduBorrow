//
//  UserViewModel.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//


import SwiftUI
import SwiftData
import Combine

final class UserViewModel: ObservableObject {

    @Published var users: [User] = []

    private let service = UserService()

    func loadUsers(context: ModelContext) {
        users = service.fetchUsers(context: context)
    }

    func createUser(
        identityNumber: String,
        name: String,
        phoneNumber: String,
        role: Role,
        context: ModelContext
    ) {
        service.addUser(
            identityNumber: identityNumber,
            name: name,
            phoneNumber: phoneNumber,
            role: role,
            context: context
        )

        loadUsers(context: context)
    }

    func updateUser(
        user: User,
        identityNumber: String,
        name: String,
        phoneNumber: String,
        role: Role,
        context: ModelContext
    ) {
        service.updateUser(
            user: user,
            identityNumber: identityNumber,
            name: name,
            phoneNumber: phoneNumber,
            role: role,
            context: context
        )

        loadUsers(context: context)
    }

    func deleteUser(user: User, context: ModelContext) {
        service.deleteUser(user: user, context: context)
        loadUsers(context: context)
    }
}
