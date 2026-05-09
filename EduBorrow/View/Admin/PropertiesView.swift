//
//  PropertiesView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI
struct PropertiesView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel

    let sampleEquipments = ["Projector", "Laptop", "Speaker", "Mic"]
    let sampleRooms = ["Room A", "Room B", "Room C", "Room D"]

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
                                ForEach(sampleEquipments.shuffled().prefix(3), id: \.self) { item in
                                    PropertyCard(title: item)
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
                                ForEach(sampleRooms.shuffled().prefix(3), id: \.self) { item in
                                    PropertyCard(title: item)
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
                        viewModel.logout()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}
