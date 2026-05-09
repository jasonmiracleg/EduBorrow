//
//  CreateRoomView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI

struct CreateRoomView: View {

    @State private var floor: String = ""
    @State private var building: String = ""
    @State private var capacity: String = ""

    @Environment(\.dismiss) var dismiss

    var body: some View {
        Form {

            Section(header: Text("Room Info")) {

                TextField("Building", text: $building)

                TextField("Floor", text: $floor)

                TextField("Capacity", text: $capacity)
                    .keyboardType(.numberPad)
            }

            Section {
                Button("Save Room") {
                    saveRoom()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Create Room")
    }

    private func saveRoom() {
        guard let capacityInt = Int(capacity),
              !building.isEmpty,
              !floor.isEmpty else {
            return
        }

        let newRoom = Room(
            floor: floor,
            building: building,
            capacity: capacityInt
        )

        // TODO: insert into SwiftData / ViewModel
        print("Saved:", newRoom)

        dismiss()
    }
}
