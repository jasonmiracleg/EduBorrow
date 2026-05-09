//
//  EquipmentCard.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//


import SwiftUI

struct EquipmentCard: View {
    
    let equipment: Equipment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // MARK: Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(equipment.equipmentName)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(equipment.equipmentId)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Stock badge
                Text("Stock: \(equipment.stock)")
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(stockColor(equipment.stock).opacity(0.2))
                    .foregroundStyle(stockColor(equipment.stock))
                    .clipShape(Capsule())
            }
            
            Divider()
            
            // MARK: Details
            HStack {
                
                VStack(alignment: .leading, spacing: 6) {
                    Label(equipment.category.rawValue, systemImage: "tag")
                    Label("Borrowed: \(equipment.borrowingRecords.count)", systemImage: "arrow.2.circlepath")
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 6) {
                    Label("Status", systemImage: "checkmark.circle")
                        .foregroundStyle(equipment.stock > 0 ? .green : .red)
                    
                    Text(equipment.stock > 0 ? "Available" : "Out of Stock")
                        .font(.caption)
                        .foregroundStyle(.secondary)
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
    
    // MARK: Stock color logic
    private func stockColor(_ stock: Int) -> Color {
        switch stock {
        case 5...:
            return .green
        case 1...4:
            return .orange
        default:
            return .red
        }
    }
}
