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
    
    func testCreateBorrowRequest_ShouldRejectWhenNoEquipmentSelected() {
        XCTAssertThrowsError(try service.createBorrowRequest(
            user: user,
            room: room,
            usageDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            duration: 2,
            purpose: "Meeting",
            selectedEquipments: [:],
            context: context
        )) { _ in
            let result = (try? context.fetch(FetchDescriptor<Borrowing>())) ?? []
            XCTAssertTrue(result.isEmpty, "Borrowing with no equipments should not be inserted")
        }
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
}
