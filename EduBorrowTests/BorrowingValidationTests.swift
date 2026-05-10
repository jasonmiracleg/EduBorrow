//
//  BorrowingValidationTests.swift
//  EduBorrow
//
//  Created by automated test generator on 10/05/26.
//

import XCTest
@testable import EduBorrow
import SwiftData

final class BorrowingValidationTests: XCTestCase {
    
    var service: BorrowingService!
    var context: FakeModelContext!
    var equipment: Equipment!
    var user: User!
    var room: Room!
    
    override func setUp() {
        super.setUp()
        service = BorrowingService()
        context = FakeModelContext()
        
        user = TestDataFactory.makeUser()
        room = TestDataFactory.makeRoom()
        
        equipment = Equipment(
            equipmentId: "E-VAL-1",
            equipmentName: "Laptop",
            stock: 2,
            category: .electronics
        )
    }
    
    override func tearDown() {
        service = nil
        context = nil
        super.tearDown()
    }
    
    func testCreateBorrowRequest_ShouldRejectZeroOrNegativeDuration() {
        XCTAssertThrowsError(try service.createBorrowRequest(
            user: user,
            room: room,
            usageDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            duration: 0,
            purpose: "Test",
            selectedEquipments: [equipment: 1],
            context: context
        )) { error in
            // ensure nothing persisted
            let result = (try? context.fetch(FetchDescriptor<Borrowing>())) ?? []
            XCTAssertTrue(result.isEmpty, "Borrowing with zero duration should not be inserted")
        }
    }
    
    func testCreateBorrowRequest_ShouldRejectMissingPurpose() {
        XCTAssertThrowsError(try service.createBorrowRequest(
            user: user,
            room: room,
            usageDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            duration: 2,
            purpose: "",
            selectedEquipments: [equipment: 1],
            context: context
        )) { _ in
            let result = (try? context.fetch(FetchDescriptor<Borrowing>())) ?? []
            XCTAssertTrue(result.isEmpty, "Borrowing with empty purpose should not be inserted")
        }
    }
    
    func testCreateBorrowRequest_ShouldAllowRoomOnlyBorrowing() {
        // Allow room-only borrowing (no equipment selected)
        XCTAssertNoThrow(try service.createBorrowRequest(
            user: user,
            room: room,
            usageDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            duration: 2,
            purpose: "Meeting",
            selectedEquipments: [:],
            context: context
        ))
        
        let result = (try? context.fetch(FetchDescriptor<Borrowing>())) ?? []
        XCTAssertEqual(result.count, 1, "Borrowing without equipment should be inserted")
    }
    
    func testCreateBorrowRequest_ShouldRejectWhenRequestedQuantityExceedsStock() {
        // request 5 but stock is 2
        XCTAssertThrowsError(try service.createBorrowRequest(
            user: user,
            room: room,
            usageDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            duration: 2,
            purpose: "Field test",
            selectedEquipments: [equipment: 5],
            context: context
        )) { _ in
            let result = (try? context.fetch(FetchDescriptor<Borrowing>())) ?? []
            XCTAssertTrue(result.isEmpty, "Borrowing requesting more than stock should not be inserted")
        }
    }

    func testCreateBorrowRequest_ShouldRejectWhenRoomNotAvailable() {
        // Prepare an existing approved borrowing that blocks the same room/time
        let existingUsage = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let existing = Borrowing(
            user: user,
            room: room,
            requestDate: Date(),
            usageDate: existingUsage,
            duration: 2,
            statusApproval: .approved,
            purpose: "Existing booking"
        )

        context.insert(existing)

        XCTAssertThrowsError(try service.createBorrowRequest(
            user: user,
            room: room,
            usageDate: existingUsage,
            duration: 2,
            purpose: "New booking",
            selectedEquipments: [:],
            context: context
        )) { error in
            if let e = error as? BorrowingService.CreateError {
                switch e {
                case .roomNotAvailable:
                    break // expected
                default:
                    XCTFail("Expected roomNotAvailable, got \(e)")
                }
            } else {
                XCTFail("Unexpected error type: \(error)")
            }
        }
    }


}
