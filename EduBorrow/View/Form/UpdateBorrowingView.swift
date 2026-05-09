//
//  UpdateBorrowingView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI
import SwiftData

struct UpdateBorrowingView: View {

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @Query private var rooms: [Room]
    @Query private var equipments: [Equipment]

    var viewModel: RequestViewModel
    var borrowing: Borrowing

    @State private var selectedRoom: Room?
    @State private var usageDate: Date = Date()
    @State private var durationInHours: Int = 1
    @State private var purpose: String = ""

    @State private var selectedEquipments: [Equipment: Int] = [:]

    var body: some View {
        NavigationStack {
            Form {
                // MARK: Room
                Section("Room") {
                    Picker("Select Room", selection: $selectedRoom) {

                        Text("Choose Room")
                            .tag(nil as Room?)

                        ForEach(rooms) { room in
                            Text("\(room.building) - Floor \(room.floor)")
                                .tag(room as Room?)
                        }
                    }
                }

                // MARK: Usage Info
                Section("Usage Information") {

                    DatePicker(
                        "Usage Date",
                        selection: $usageDate,
                        in: Date()...,   
                        displayedComponents: [.date]
                    )

                    Stepper(
                        "Duration: \(durationInHours) hour(s)",
                        value: $durationInHours,
                        in: 1...12
                    )

                    TextField("Purpose", text: $purpose, axis: .vertical)
                        .lineLimit(3...5)
                }

                // MARK: Equipments
                Section("Equipments") {

                    ForEach(equipments) { equipment in

                        HStack {

                            VStack(alignment: .leading) {
                                Text(equipment.equipmentName)

                                Text("Stock: \(equipment.stock)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Stepper(
                                value: binding(for: equipment),
                                in: 0...equipment.stock
                            ) {
                                Text("\(selectedEquipments[equipment] ?? 0)")
                            }
                            .frame(width: 120)
                        }
                    }
                }

                // MARK: Save Button
                Section {
                    Button {
                        guard let room = selectedRoom else { return }

                        viewModel.updateBorrowing(
                            borrowing: borrowing,
                            room: room,
                            usageDate: usageDate,
                            duration: durationInHours,
                            purpose: purpose,
                            selectedEquipments: selectedEquipments,
                            context: context
                        )

                        dismiss()
                    } label: {
                        Text("Update Request")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(
                        selectedRoom == nil ||
                        purpose.trimmingCharacters(in: .whitespaces).isEmpty
                    )
                }
            }
            .navigationTitle("Update Request")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadExistingData()
            }
        }
    }
}

extension UpdateBorrowingView {

    private func binding(for equipment: Equipment) -> Binding<Int> {
        Binding {
            selectedEquipments[equipment] ?? 0
        } set: { newValue in
            selectedEquipments[equipment] = newValue
        }
    }
}

extension UpdateBorrowingView {

    private func loadExistingData() {

        selectedRoom = borrowing.room
        usageDate = borrowing.usageDate
        durationInHours = borrowing.durationInHours
        purpose = borrowing.purpose

        selectedEquipments = Dictionary(
            uniqueKeysWithValues: borrowing.borrowedEquipments.map {
                ($0.equipment, $0.quantity)
            }
        )
    }
}
