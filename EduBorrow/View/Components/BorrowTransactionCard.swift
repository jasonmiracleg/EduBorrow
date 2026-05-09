//
//  BorrowTransactionCard.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//


import SwiftUI

struct BorrowTransactionCard: View {

    let transaction: Borrowing

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // MARK: Header
            HStack {
                Text(transaction.user.name)
                    .font(.headline)

                Spacer()

                Text(transaction.statusApproval.rawValue.capitalized)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(statusColor(transaction.statusApproval).opacity(0.2))
                    .foregroundStyle(statusColor(transaction.statusApproval))
                    .clipShape(Capsule())
            }

            Divider()

            // MARK: Details
            VStack(alignment: .leading, spacing: 6) {

                Label("Room: \(transaction.room.roomName)", systemImage: "door.left.hand.open")

                // FIXED: multiple equipments
                VStack(alignment: .leading, spacing: 4) {
                    Label("Equipments", systemImage: "wrench.and.screwdriver")

                    ForEach(transaction.borrowedEquipments) { item in
                        HStack(alignment: .firstTextBaseline) {
                            Text("• \(item.equipment.equipmentName)")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Spacer()

                            Text("x\(item.quantity)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Label("Duration: \(transaction.durationInHours) hrs", systemImage: "clock")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            // MARK: Dates
            HStack {
                Text("Requested:")
                Spacer()
                Text(transaction.requestDate, style: .date)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        )
    }

    // MARK: Status color
    private func statusColor(_ status: Approval) -> Color {
        switch status {
        case .approved:
            return .green
        case .pending:
            return .orange
        case .rejected:
            return .red
        case .finished:
            return .blue
        }
    }
}
