//
//  RequestViewModelTests.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 10/05/26.
//

import XCTest
@testable import EduBorrow
import SwiftData

@MainActor
final class RequestViewModelTests: XCTestCase {

    var vm: RequestViewModel!
    var context: FakeModelContext!
    var user: User!
    var room: Room!
    var equipment: Equipment!

    override func setUp() {
        super.setUp()
        vm = RequestViewModel()
        context = FakeModelContext()

        user = TestDataFactory.makeUser()
        room = TestDataFactory.makeRoom()

        equipment = Equipment(
            equipmentId: "EQ-01",
            equipmentName: "Projector",
            stock: 2,
            category: .electronics
        )
    }

    override func tearDown() {
        vm = nil
        context = nil
        super.tearDown()
    }

    func testCreateBorrowRequest_InvalidDuration_ShouldNotInsert() {
        vm.createBorrowRequest(
            user: user,
            room: room,
            usageDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            duration: 0,
            purpose: "Test",
            selectedEquipments: [equipment: 1],
            context: context
        )

        let all = (try? context.fetch(FetchDescriptor<Borrowing>())) ?? []
        XCTAssertTrue(all.isEmpty)
    }

    func testCreateBorrowRequest_EmptyPurpose_ShouldNotInsert() {
        vm.createBorrowRequest(
            user: user,
            room: room,
            usageDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            duration: 2,
            purpose: "",
            selectedEquipments: [equipment: 1],
            context: context
        )

        let all = (try? context.fetch(FetchDescriptor<Borrowing>())) ?? []
        XCTAssertTrue(all.isEmpty)
    }

    func testCreateBorrowRequest_NoEquipmentSelected_ShouldInsert() {
        vm.createBorrowRequest(
            user: user,
            room: room,
            usageDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            duration: 2,
            purpose: "Meeting",
            selectedEquipments: [:],
            context: context
        )

        let all = (try? context.fetch(FetchDescriptor<Borrowing>())) ?? []
        XCTAssertEqual(all.count, 1)
    }

    func testCreateBorrowRequest_RequestExceedsStock_ShouldNotInsert() {
        // equipment.stock is 2, request 5
        vm.createBorrowRequest(
            user: user,
            room: room,
            usageDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            duration: 2,
            purpose: "Field test",
            selectedEquipments: [equipment: 5],
            context: context
        )

        let all = (try? context.fetch(FetchDescriptor<Borrowing>())) ?? []
        XCTAssertTrue(all.isEmpty)
    }

    func testApproveBorrowing_WithSufficientStock_SetsApprovalMessage() {
        // prepare borrowing and insert into fake context
        equipment.stock = 10

        let borrowing = TestDataFactory.makeValidBorrowing()

        let item = BorrowingEquipment(borrowing: borrowing, equipment: equipment, quantity: 3)
        borrowing.borrowedEquipments = [item]

        context.insert(borrowing)

        vm.approve(borrowing: borrowing, context: context)

        XCTAssertEqual(vm.approvalMessage, "Request approved successfully")
    }
}
