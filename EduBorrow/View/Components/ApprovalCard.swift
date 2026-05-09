//
//  ApprovalCard.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftData
import SwiftUI

struct ApprovalCard: View {
    let request: Borrowing

    let onApprove: () -> Void
    let onReject: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // MARK: Top Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(request.user.name)
                        .font(.headline)
                        .fontWeight(.semibold)

                    Text(request.room.roomName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("\(request.durationInHours)h")
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.gray.opacity(0.15))
                    .clipShape(Capsule())
            }

            Divider()

            // MARK: Equipment Section
            VStack(alignment: .leading, spacing: 6) {
                Text("Equipment")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 6) {
                    ForEach(request.borrowedEquipments) { item in
                        HStack {
                            Circle()
                                .fill(.blue.opacity(0.7))
                                .frame(width: 6, height: 6)

                            Text(item.equipment.equipmentName)
                                .font(.subheadline)

                            Spacer()

                            Text("x\(item.quantity)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.leading, 4)
            }

            Divider()

            // MARK: Actions
            HStack(spacing: 12) {

                Button {
                    onApprove()
                } label: {
                    Text("Approve")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button(role: .destructive) {
                    onReject()
                } label: {
                    Text("Reject")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
        )
    }
}
