//
//  AllEquipmentView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//


import SwiftUI
import SwiftData

struct AllEquipmentView: View {

    @Environment(\.modelContext) var context
    @ObservedObject var equipmentVM: EquipmentViewModel
    @State private var selectedEquipment: Equipment?

    var body: some View {
        NavigationStack {
            ScrollView {
                
                if equipmentVM.equipments.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "wrench.and.screwdriver")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)

                        Text("No equipment available")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
                    
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(equipmentVM.equipments, id: \.equipmentId) { item in
                            EquipmentCard(equipment: item)
                                .contextMenu {

                                    Button {
                                        selectedEquipment = item
                                    } label: {
                                        Label("Update", systemImage: "pencil")
                                    }

                                    Button(role: .destructive) {
                                        equipmentVM.deleteEquipment(
                                            equipment: item,
                                            context: context
                                        )
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("All Equipment")
            .sheet(item: $selectedEquipment) { equipment in
                UpdateEquipmentView(equipment: equipment)
            }
        }
    }
}
