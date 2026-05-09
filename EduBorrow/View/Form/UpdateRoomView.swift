//
//  UpdateRoomView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI
import SwiftData

struct UpdateRoomView: View {

    var room: Room

    @State private var floor: String
    @State private var building: String
    @State private var capacity: String

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context

    @StateObject private var viewModel = RoomViewModel()

    init(room: Room) {
        self.room = room
        _floor = State(initialValue: room.floor)
        _building = State(initialValue: room.building)
        _capacity = State(initialValue: "\(room.capacity)")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Room Info")) {

                    TextField("Building", text: $building)

                    TextField("Floor", text: $floor)

                    TextField("Capacity", text: $capacity)
                        .keyboardType(.numberPad)
                }

                Section {
                    Button("Update Room") {
                        viewModel.updateRoom(room: room, floor: floor, building: building, capacity: Int(capacity)!, context: context)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Update Room")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
