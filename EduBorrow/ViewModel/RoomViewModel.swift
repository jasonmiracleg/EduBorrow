//
//  RoomViewModel.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import Combine
import Foundation
import SwiftData

@MainActor
final class RoomViewModel: ObservableObject {

    @Published var rooms: [Room] = []

    private let service = RoomService()

    // MARK: - LOAD
    func loadRooms(context: ModelContext) {
        rooms = service.fetchRooms(context: context)
    }

    // MARK: - CREATE
    func addRoom(
        floor: String,
        building: String,
        capacity: Int,
        context: ModelContext
    ) {
        service.createRoom(
            floor: floor,
            building: building,
            capacity: capacity,
            context: context
        )
        loadRooms(context: context)
    }

    // MARK: - UPDATE
    func updateRoom(room: Room, newName: String, context: ModelContext) {
        service.updateRoom(room: room, newName: newName, context: context)
        loadRooms(context: context)
    }

    // MARK: - DELETE
    func deleteRoom(room: Room, context: ModelContext) {
        service.deleteRoom(room: room, context: context)
        loadRooms(context: context)
    }
}
