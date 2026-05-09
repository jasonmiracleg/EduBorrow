//
// EquipmentViewModelTests.swift
// EduBorrow
//

import XCTest
@testable import EduBorrow
import SwiftData

@MainActor
final class EquipmentViewModelTests: XCTestCase {

    var vm: EquipmentViewModel!
    var context: FakeModelContext!

    override func setUp() {
        super.setUp()
        vm = EquipmentViewModel()
        context = FakeModelContext()
    }

    override func tearDown() {
        vm = nil
        context = nil
        super.tearDown()
    }

    func testAddEquipment_InsertsEquipmentWithGeneratedId() {
        vm.addEquipment(name: "Camera", stock: 3, category: .electronics, context: context)

        let all = (try? context.fetch(FetchDescriptor<Equipment>())) ?? []
        XCTAssertEqual(all.count, 1)
        XCTAssertTrue(all.first?.equipmentId.contains("-") ?? false)
    }

    func testDeleteEquipment_RemovesFromContext() {
        let eq = Equipment(equipmentId: "E-DEL-1", equipmentName: "Old", stock: 1, category: .electronics)
        context.insert(eq)

        vm.deleteEquipment(equipment: eq, context: context)

        let all = (try? context.fetch(FetchDescriptor<Equipment>())) ?? []
        XCTAssertTrue(all.isEmpty)
    }
}
