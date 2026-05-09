//
//  AuthenticationViewModel.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import Combine
import Foundation
import SwiftData

@MainActor
class AuthenticationViewModel: ObservableObject {

    @Published var identityNumber = ""
    @Published var password = ""
    @Published var isPasswordVisible = false
    @Published var loginMessage = ""
    @Published var isAuthenticated = false
    @Published var user: User?

    private let authService = AuthenticationService()

    func login(context: ModelContextType) {

        let success = authService.authenticate(
            identityNumber: identityNumber,
            password: password,
            context: context
        )

        if success {
            loginMessage = "Login Successful"
            isAuthenticated = true

            user = authService.getAuthenticatedUser(
                identityNumber: identityNumber,
                context: context
            )

        } else {
            loginMessage = "Invalid Credentials"
            isAuthenticated = false
            user = nil
        }
    }

    func logout() {
        isAuthenticated = false
        user = nil

        identityNumber = ""
        password = ""
        loginMessage = ""
    }
}
