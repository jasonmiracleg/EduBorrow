//
// EquipmentServiceCRUDTests.swift
// EduBorrow
//

import XCTest
@testable import EduBorrow
import SwiftData

final class EquipmentServiceCRUDTests: XCTestCase {

    var service: EquipmentService!
    var context: FakeModelContext!

    override func setUp() {
        super.setUp()
        service = EquipmentService()
        context = FakeModelContext()
    }

    override func tearDown() {
        service = nil
        context = nil
        super.tearDown()
    }

    func testCreateEquipment_InsertsAndFetchable() {
        service.createEquipment(equipmentId: "EQ-1", name: "Projector", stock: 2, category: .electronics, context: context)

        let all = (try? context.fetch(FetchDescriptor<Equipment>())) ?? []
        XCTAssertEqual(all.count, 1)
        let first = all.first
        XCTAssertEqual(first?.equipmentId, "EQ-1")
        XCTAssertEqual(first?.equipmentName, "Projector")
        XCTAssertEqual(first?.stock, 2)
        XCTAssertEqual(first?.category, .electronics)
    }

    func testUpdateEquipment_ChangesProperties() {
        let eq = Equipment(equipmentId: "EQ-2", equipmentName: "Old", stock: 1, category: .audioVisual)
        context.insert(eq)

        service.updateEquipment(equipment: eq, name: "NewName", stock: 5, category: .electronics, context: context)

        let all = (try? context.fetch(FetchDescriptor<Equipment>())) ?? []
        XCTAssertEqual(all.count, 1)
        let updated = all.first
        XCTAssertEqual(updated?.equipmentName, "NewName")
        XCTAssertEqual(updated?.stock, 5)
        XCTAssertEqual(updated?.category, .electronics)
    }

    func testDeleteEquipment_RemovesEquipment() {
        let eq = Equipment(equipmentId: "EQ-DEL", equipmentName: "ToDelete", stock: 1, category: .electronics)
        context.insert(eq)

        service.deleteEquipment(equipment: eq, context: context)

        let all = (try? context.fetch(FetchDescriptor<Equipment>())) ?? []
        XCTAssertTrue(all.isEmpty)
    }

    func testFetchEquipment_ReturnsAllInserted() {
        let a = Equipment(equipmentId: "A", equipmentName: "A1", stock: 1, category: .electronics)
        let b = Equipment(equipmentId: "B", equipmentName: "B1", stock: 2, category: .audioVisual)
        context.insert(a)
        context.insert(b)

        let all = service.fetchEquipment(context: context)
        XCTAssertEqual(all.count, 2)
        // ids present
        let ids = Set(all.map { $0.equipmentId })
        XCTAssertTrue(ids.contains("A") && ids.contains("B"))
    }
}
