//
//  PropertiesView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI
import SwiftData

struct PropertiesView: View {

    @EnvironmentObject var authVM: AuthenticationViewModel

    @Environment(\.modelContext) var context

    @StateObject private var equipmentVM = EquipmentViewModel()
    @StateObject private var roomVM = RoomViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    // MARK: Navigation Cards
                    VStack(spacing: 16) {

                        ActionCard(
                            title: "Create Equipment",
                            description: "Add new academic equipment to inventory.",
                            icon: "wrench.and.screwdriver.fill",
                            color: .blue,
                            destination: CreateEquipmentView()
                        )

                        ActionCard(
                            title: "Create Room",
                            description: "Register a new room for borrowing system.",
                            icon: "door.left.hand.open",
                            color: .green,
                            destination: CreateRoomView()
                        )
                    }
                    .padding(.top)

                    // MARK: Equipments
                    VStack(alignment: .leading) {
                        Text("Equipments")
                            .font(.headline)

                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 12) {
                                ForEach(equipmentVM.equipments.prefix(5), id: \.equipmentId) { item in
                                    PropertyCard(
                                        title: item.equipmentName,
                                        subtitle: "\(item.equipmentId) • Stock: \(item.stock)"
                                    )
                                }
                            }
                        }
                    }

                    // MARK: Rooms
                    VStack(alignment: .leading) {
                        Text("Rooms")
                            .font(.headline)

                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 12) {
                                ForEach(roomVM.rooms.prefix(5), id: \.id) { room in
                                    PropertyCard(
                                        title: "\(room.building) - F\(room.floor)",
                                        subtitle: "Capacity: \(room.capacity)"
                                    )
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Properties")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        authVM.logout()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }
            }
            .onAppear {
                equipmentVM.loadEquipment(context: context)
                roomVM.loadRooms(context: context)
            }
        }
    }
}
