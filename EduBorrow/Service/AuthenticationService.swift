//
//  AuthenticationService.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import Foundation
import SwiftData

final class AuthenticationService {

    func authenticate(
        identityNumber: String,
        password: String,
        context: ModelContextType
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
    
    func getAuthenticatedUser(
        identityNumber: String,
        context: ModelContextType
    ) -> User? {

        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate {
                $0.identityNumber == identityNumber
            }
        )

        do {
            return try context.fetch(descriptor).first
        } catch {
            print("Fetch User Error: \(error)")
            return nil
        }
    }
}
