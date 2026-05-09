//
//  TestDataFactory.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 10/05/26.
//

import Foundation
@testable import EduBorrow

import Foundation

enum TestDataFactory {

    // MARK: - USER

    static func makeUser() -> User {
        User(
            identityNumber: "1234567890",
            name: "Test User",
            phoneNumber: "1234567890",
            password: "test",
            role: .student
        )
    }
    
    static func makeAdmin() -> User {
        User(
            identityNumber: "1234567890",
            name: "Test Admin",
            phoneNumber: "1234567890",
            password: "test",
            role: .admin
        )
    }
    
    static func makeInvalidUser() -> User {
        User(
            identityNumber: "",
            name: "",
            phoneNumber: "",
            password: "test",
            role: .student
        )
    }

    // MARK: - ROOM

    static func makeRoom() -> Room {
        Room(
            floor: "7",
            building: "UC Tower",
            capacity: 10
        )
    }

    // MARK: - BORROWING (VALID)

    static func makeValidBorrowing() -> Borrowing {
        let user = makeUser()
        let room = makeRoom()

        return Borrowing(
            user: user,
            room: room,
            requestDate: Date(),
            usageDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            duration: 2,
            statusApproval: .pending,
            purpose: "Test purpose"
        )
    }

    // MARK: - INVALID: ZERO DURATION

    static func makeZeroDurationBorrowing() -> Borrowing {
        let user = makeUser()
        let room = makeRoom()

        return Borrowing(
            user: user,
            room: room,
            requestDate: Date(),
            usageDate: Date(),
            duration: 0,
            statusApproval: .pending,
            purpose: "Invalid duration test"
        )
    }

    // MARK: - INVALID: PAST USAGE DATE

    static func makePastDateBorrowing() -> Borrowing {
        let user = makeUser()
        let room = makeRoom()

        return Borrowing(
            user: user,
            room: room,
            requestDate: Date(),
            usageDate: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
            duration: 2,
            statusApproval: .pending,
            purpose: "Past date test"
        )
    }

    // MARK: - INVALID: MISSING PURPOSE

    static func makeMissingPurposeBorrowing() -> Borrowing {
        let user = makeUser()
        let room = makeRoom()

        return Borrowing(
            user: user,
            room: room,
            requestDate: Date(),
            usageDate: Date(),
            duration: 2,
            statusApproval: .pending,
            purpose: ""
        )
    }

    // MARK: - INVALID: MISSING USER

    static func makeInvalidUserBorrowing() -> Borrowing {
        let room = makeRoom()
        let user = makeInvalidUser()

        return Borrowing(
            user: user,
            room: room,
            requestDate: Date(),
            usageDate: Date(),
            duration: 2,
            statusApproval: .pending,
            purpose: "No user"
        )
    }
}
