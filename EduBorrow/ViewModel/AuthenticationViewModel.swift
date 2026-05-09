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

    private let authService = AuthenticationService()

    func login(context: ModelContext) {
        let success = authService.authenticate(
            identityNumber: identityNumber,
            password: password,
            context: context
        )

        if success {
            loginMessage = "Login Successful"
            isAuthenticated = true
        } else {
            loginMessage = "Invalid Credentials"
            isAuthenticated = false
        }
    }
}
