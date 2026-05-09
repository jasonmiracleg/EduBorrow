//
//  AllRoomsView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftData
import SwiftUI

struct AllRoomsView: View {

    @Environment(\.modelContext) var context
    @ObservedObject var roomVM: RoomViewModel
    @State private var selectedRoom: Room?

    var body: some View {
        NavigationStack {
            ScrollView {
                
                if roomVM.rooms.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "door.left.hand.open")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)

                        Text("No rooms available")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
                    
                } else {
                    LazyVStack(spacing: 12) {
                        
                        ForEach(roomVM.rooms) { room in
                            RoomCard(room: room)
                                .contextMenu {
                                    Button {
                                        selectedRoom = room
                                    } label: {
                                        Label("Update", systemImage: "pencil")
                                    }

                                    Button(role: .destructive) {
                                        roomVM.deleteRoom(
                                            room: room,
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
            .navigationTitle("All Rooms")
            .sheet(item: $selectedRoom) { room in
                UpdateRoomView(room: room)
            }
        }
    }
}
