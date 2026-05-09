//
// ValidationServiceTests.swift
// EduBorrow
//

import XCTest
@testable import EduBorrow

final class ValidationServiceTests: XCTestCase {

    var svc: ValidationService!

    override func setUp() {
        super.setUp()
        svc = ValidationService()
    }

    override func tearDown() {
        svc = nil
        super.tearDown()
    }

    func testValidDateString_MatchesFormat() {
        let valid = "2026-05-10 14:30"
        XCTAssertTrue(svc.isValidDateString(valid, format: "yyyy-MM-dd HH:mm"))
    }

    func testInvalidDateString_DoesNotMatch() {
        let invalid = "10/05/2026 14:30"
        XCTAssertFalse(svc.isValidDateString(invalid, format: "yyyy-MM-dd HH:mm"))
    }

    func testEmptyString_IsInvalid() {
        XCTAssertFalse(svc.isValidDateString("", format: "yyyy-MM-dd"))
    }
}
