//
//  AuthenticationService.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import Foundation
import SwiftData

class AuthenticationService {

    func authenticate(
        identityNumber: String,
        password: String,
        context: ModelContext
    ) -> Bool {

        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate {
                $0.identityNumber == identityNumber
            }
        )

        do {
            guard let user = try context.fetch(descriptor).first else {
                return false
            }
            let hashedPassword = User.hashPassword(password)
            return user.passwordHash == hashedPassword
        } catch {
            print("Authentication Error: \(error)")
            return false
        }
    }
}
