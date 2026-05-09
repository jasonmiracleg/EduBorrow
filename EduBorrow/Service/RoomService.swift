//
//  RoomService.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftData
import Foundation

final class RoomService {

    // CREATE
    func createRoom(floor: String, building: String, capacity: Int, context: ModelContextType) {
        let room = Room(floor: floor, building: building, capacity: capacity)
        context.insert(room)

        save(context: context)
    }

    // READ
    func fetchRooms(context: ModelContextType) -> [Room] {
        let descriptor = FetchDescriptor<Room>()
        return (try? context.fetch(descriptor)) ?? []
    }

    // UPDATE
    func updateRoom(room: Room, building: String, floor: String, capacity: Int, context: ModelContextType) {
        room.roomName = "Room \(floor)-\(building)-\(capacity)"
        room.building = building
        room.floor = floor
        room.capacity = capacity
        save(context: context)
    }

    // DELETE
    func deleteRoom(room: Room, context: ModelContextType) {
        context.delete(room)
        save(context: context)
    }

    // MARK: - Private
    private func save(context: ModelContextType) {
        do {
            try context.save()
        } catch {
            print("RoomService Save Error: \(error)")
        }
    }
}
