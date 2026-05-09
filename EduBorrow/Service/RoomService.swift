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
    func createRoom(floor: String, building: String, capacity: Int, context: ModelContext) {
        let room = Room(floor: floor, building: building, capacity: capacity)
        context.insert(room)

        save(context: context)
    }

    // READ
    func fetchRooms(context: ModelContext) -> [Room] {
        let descriptor = FetchDescriptor<Room>()
        return (try? context.fetch(descriptor)) ?? []
    }

    // UPDATE
    func updateRoom(room: Room, newName: String, context: ModelContext) {
        room.roomName = newName
        save(context: context)
    }

    // DELETE
    func deleteRoom(room: Room, context: ModelContext) {
        context.delete(room)
        save(context: context)
    }

    // MARK: - Private
    private func save(context: ModelContext) {
        do {
            try context.save()
        } catch {
            print("RoomService Save Error: \(error)")
        }
    }
}
