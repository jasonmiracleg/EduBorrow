//
// AuthenticationViewModelTests.swift
// EduBorrow
//

import XCTest
@testable import EduBorrow
import SwiftData

@MainActor
final class AuthenticationViewModelTests: XCTestCase {

    var vm: AuthenticationViewModel!
    var context: FakeModelContext!

    override func setUp() {
        super.setUp()
        vm = AuthenticationViewModel()
        context = FakeModelContext()
    }

    override func tearDown() {
        vm = nil
        context = nil
        super.tearDown()
    }

    func testLogin_ValidCredentials_ShouldAuthenticate() {
        let user = TestDataFactory.makeUser()
        context.insert(user)

        vm.identityNumber = user.identityNumber
        vm.password = "test"

        vm.login(context: context)

        XCTAssertTrue(vm.isAuthenticated)
        XCTAssertNotNil(vm.user)
        XCTAssertEqual(vm.loginMessage, "Login Successful")
    }

    func testLogin_InvalidCredentials_ShouldNotAuthenticate() {
        // no user in context
        vm.identityNumber = "unknown"
        vm.password = "wrong"

        vm.login(context: context)

        XCTAssertFalse(vm.isAuthenticated)
        XCTAssertNil(vm.user)
        XCTAssertEqual(vm.loginMessage, "Invalid Credentials")
    }
}
