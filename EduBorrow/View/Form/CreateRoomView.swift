//
//  CreateRoomView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI
import SwiftData

struct CreateRoomView: View {

    @State private var floor: String = ""
    @State private var building: String = ""
    @State private var capacity: String = ""

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context

    @StateObject private var viewModel = RoomViewModel()

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
                    guard let capacityInt = Int(capacity),
                          !building.isEmpty,
                          !floor.isEmpty else {
                        return
                    }

                    viewModel.addRoom(
                        floor: floor,
                        building: building,
                        capacity: capacityInt,
                        context: context
                    )

                    dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .disabled(!isFormValid)
            }
        }
        .navigationTitle("Create Room")
    }
    
    private var isFormValid: Bool {
        guard let capacityInt = Int(capacity) else { return false }

        return !building.trimmingCharacters(in: .whitespaces).isEmpty
            && !floor.trimmingCharacters(in: .whitespaces).isEmpty
            && capacityInt > 0
    }
}
