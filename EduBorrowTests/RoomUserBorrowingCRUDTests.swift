//
// RoomUserBorrowingCRUDTests.swift
// EduBorrow
//

import XCTest
@testable import EduBorrow
import SwiftData

final class RoomUserBorrowingCRUDTests: XCTestCase {

    var roomService: RoomService!
    var userService: UserService!
    var borrowingService: BorrowingService!
    var context: FakeModelContext!

    override func setUp() {
        super.setUp()
        roomService = RoomService()
        userService = UserService()
        borrowingService = BorrowingService()
        context = FakeModelContext()
    }

    override func tearDown() {
        roomService = nil
        userService = nil
        borrowingService = nil
        context = nil
        super.tearDown()
    }

    // MARK: - Room CRUD
    func testRoomCRUD_CreateUpdateDelete() {
        // Create
        roomService.createRoom(floor: "1", building: "A", capacity: 10, context: context)

        var rooms = roomService.fetchRooms(context: context)
        XCTAssertEqual(rooms.count, 1)

        let room = rooms[0]
        XCTAssertEqual(room.floor, "1")
        XCTAssertEqual(room.building, "A")
        XCTAssertEqual(room.capacity, 10)

        // Update
        roomService.updateRoom(room: room, building: "B", floor: "2", capacity: 20, context: context)

        rooms = roomService.fetchRooms(context: context)
        XCTAssertEqual(rooms.count, 1)
        let updated = rooms[0]
        XCTAssertEqual(updated.floor, "2")
        XCTAssertEqual(updated.building, "B")
        XCTAssertEqual(updated.capacity, 20)

        // Delete
        roomService.deleteRoom(room: updated, context: context)
        rooms = roomService.fetchRooms(context: context)
        XCTAssertTrue(rooms.isEmpty)
    }

    // MARK: - User CRUD
    func testUserCRUD_AddUpdateDelete() {
        // Add
        userService.addUser(identityNumber: "ID001", name: "Alice Smith", phoneNumber: "081234", role: .student, context: context)

        var users = userService.fetchUsers(context: context)
        XCTAssertEqual(users.count, 1)

        var user = users[0]
        XCTAssertEqual(user.identityNumber, "ID001")
        XCTAssertEqual(user.name, "Alice Smith")
        XCTAssertEqual(user.role, .student)

        // Update
        userService.updateUser(user: user, identityNumber: "ID002", name: "Alice Updated", phoneNumber: "09999", role: .admin, context: context)

        users = userService.fetchUsers(context: context)
        XCTAssertEqual(users.count, 1)
        let updated = users[0]
        XCTAssertEqual(updated.identityNumber, "ID002")
        XCTAssertEqual(updated.name, "Alice Updated")
        XCTAssertEqual(updated.role, .admin)

        // Delete
        userService.deleteUser(user: updated, context: context)
        users = userService.fetchUsers(context: context)
        XCTAssertTrue(users.isEmpty)
    }

    // MARK: - Borrowing CRUD
    func testBorrowingCRUD_CreateUpdateDelete() {
        // Prepare related entities
        let user = User(identityNumber: "U-1", name: "Bob", phoneNumber: "0800", password: "pw", role: .student)
        let room = Room(floor: "3", building: "C", capacity: 5)
        let eq1 = Equipment(equipmentId: "EQ-1", equipmentName: "Projector", stock: 3, category: .electronics)
        let eq2 = Equipment(equipmentId: "EQ-2", equipmentName: "Speaker", stock: 2, category: .electronics)

        // insert into context
        context.insert(user)
        context.insert(room)
        context.insert(eq1)
        context.insert(eq2)

        // Create borrowing (usage date in future)
        let usage = Date().addingTimeInterval(3600)
        do {
            try borrowingService.createBorrowRequest(user: user, room: room, usageDate: usage, duration: 2, purpose: "Test", selectedEquipments: [eq1: 1, eq2: 1], context: context)
        } catch {
            XCTFail("Unexpected createBorrowRequest error: \(error)")
        }

        var all = borrowingService.fetchAllBorrowings(context: context)
        XCTAssertEqual(all.count, 1)

        var borrowing = all[0]
        XCTAssertEqual(borrowing.user.userId, user.userId)
        XCTAssertEqual(borrowing.room.roomId, room.roomId)
        XCTAssertEqual(borrowing.durationInHours, 2)
        XCTAssertEqual(borrowing.purpose, "Test")
        XCTAssertEqual(borrowing.borrowedEquipments.count, 2)

        // Update borrowing: change duration and equipments
        let newUsage = Date().addingTimeInterval(7200)
        borrowingService.updateBorrowing(borrowing: borrowing, room: room, usageDate: newUsage, duration: 4, purpose: "Updated", selectedEquipments: [eq1: 2], context: context)

        all = borrowingService.fetchAllBorrowings(context: context)
        XCTAssertEqual(all.count, 1)
        let updated = all[0]
        XCTAssertEqual(updated.durationInHours, 4)
        XCTAssertEqual(updated.purpose, "Updated")
        XCTAssertEqual(updated.borrowedEquipments.count, 1)
        XCTAssertEqual(updated.borrowedEquipments.first?.equipment.equipmentId, eq1.equipmentId)

        // Delete borrowing
        borrowingService.deleteBorrowing(updated, context: context)
        all = borrowingService.fetchAllBorrowings(context: context)
        XCTAssertTrue(all.isEmpty)
    }
}
