//
//  RoomCard.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI

struct RoomCard: View {
    
    let room: Room
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // MARK: Room Title
            HStack {
                Text(room.roomName)
                    .font(.headline)
                    .lineLimit(1)
                
                Spacer()
                
                // Availability badge
                Text(room.isAvailable ? "Available" : "Occupied")
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(room.isAvailable ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    .foregroundStyle(room.isAvailable ? .green : .red)
                    .clipShape(Capsule())
            }
            
            Divider()
            
            // MARK: Room Details
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Label("Floor: \(room.floor)", systemImage: "building.2")
                    Label("Building: \(room.building)", systemImage: "building")
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 6) {
                    Label("Capacity: \(room.capacity)", systemImage: "person.3.fill")
                    Label("Borrowings: \(room.borrowings.count)", systemImage: "arrow.2.circlepath")
                }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
        )
    }
}
