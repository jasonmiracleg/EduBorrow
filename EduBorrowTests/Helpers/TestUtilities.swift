//
//  TestUtilities.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 10/05/26.
//

import Foundation
import XCTest

enum TestUtilities {

    // MARK: - ASSERTIONS

    /// Use this when you expect a function to throw an error
    static func assertThrowsError(
        _ expression: @autoclosure () throws -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            try expression()
            XCTFail("Expected error but got success", file: file, line: line)
        } catch {
            // Success: error was thrown
        }
    }

    /// Use this when you expect NO error (clean success case)
    static func assertNoThrow(
        _ expression: @autoclosure () throws -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            try expression()
        } catch {
            XCTFail("Expected success but got error: \(error)", file: file, line: line)
        }
    }

    // MARK: - DATE HELPERS

    static func makeDate(daysFromNow: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: daysFromNow, to: Date())!
    }

    static func makeDate(hoursFromNow: Int) -> Date {
        Calendar.current.date(byAdding: .hour, value: hoursFromNow, to: Date())!
    }

    static func makePastDate(daysAgo: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())!
    }

    static func makeFutureDate(daysAhead: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: daysAhead, to: Date())!
    }

    // MARK: - COMMON TEST HELPERS

    static func fail(_ message: String,
                     file: StaticString = #file,
                     line: UInt = #line) {
        XCTFail(message, file: file, line: line)
    }

    static func expectTrue(_ condition: Bool,
                           _ message: String,
                           file: StaticString = #file,
                           line: UInt = #line) {
        if !condition {
            XCTFail(message, file: file, line: line)
        }
    }

    static func expectFalse(_ condition: Bool,
                            _ message: String,
                            file: StaticString = #file,
                            line: UInt = #line) {
        if condition {
            XCTFail(message, file: file, line: line)
        }
    }
}
