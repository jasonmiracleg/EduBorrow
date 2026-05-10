//
//  CreateBorrowingView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI
import SwiftData

struct CreateBorrowingView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Query private var rooms: [Room]
    @Query private var equipments: [Equipment]
    
    var viewModel: RequestViewModel
    
    var currentUser: User
    
    @State private var selectedRoom: Room?
    @State private var usageDate: Date = Date()
    @State private var durationInHours: Int = 1
    @State private var purpose: String = ""
    
    @State private var selectedEquipments: [Equipment: Int] = [:]
    @State private var showAlert: Bool = false
    
    var body: some View {
        
        Form {
            
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
            
            Section("Usage Information") {
                
                DatePicker(
                    "Usage Date",
                    selection: $usageDate,
                    in: Date()...,   // 👈 prevents past dates
                    displayedComponents: [.date, .hourAndMinute]
                )
                
                Stepper(
                    "Duration: \(durationInHours) hour(s)",
                    value: $durationInHours,
                    in: 1...12
                )
                
                TextField("Purpose", text: $purpose, axis: .vertical)
                    .lineLimit(3...5)
            }
            
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
            
            Section {
                Button {
                    guard let room = selectedRoom else { return }
                    
                    viewModel.createBorrowRequest(
                        user: currentUser,
                        room: room,
                        usageDate: usageDate,
                        duration: durationInHours,
                        purpose: purpose,
                        selectedEquipments: selectedEquipments,
                        context: context
                    )
                    
                    if viewModel.approvalMessage != nil {
                        showAlert = true
                    } else {
                        dismiss()
                    }
                } label: {
                    Text("Submit Request")
                        .frame(maxWidth: .infinity)
                }
                .disabled(
                    selectedRoom == nil ||
                    purpose.trimmingCharacters(in: .whitespaces).isEmpty
                )
            }
        }
        .navigationTitle("Create Request")
        .alert("Create Request", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                viewModel.approvalMessage = nil
            }
        } message: {
            Text(viewModel.approvalMessage ?? "")
        }
    }
}

extension CreateBorrowingView {
    
    private func binding(for equipment: Equipment) -> Binding<Int> {
        
        Binding {
            selectedEquipments[equipment] ?? 0
        } set: { newValue in
            selectedEquipments[equipment] = newValue
        }
    }
}
