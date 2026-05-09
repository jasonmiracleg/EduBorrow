//
//  UserCard.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//


import SwiftUI

struct UserCard: View {

    let name: String
    let identityNumber: String
    let role: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.headline)
                        .lineLimit(1)

                    Text(identityNumber)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(role.capitalized)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(roleColor(role).opacity(0.2))
                    .foregroundStyle(roleColor(role))
                    .clipShape(Capsule())
            }

            Divider()

            HStack {
                Label("User Role", systemImage: "person.fill")
                Spacer()
                Label("ID Verified", systemImage: "checkmark.seal")
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
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private func roleColor(_ role: String) -> Color {
        switch role.lowercased() {
        case "admin":
            return .red
        case "staff":
            return .blue
        default:
            return .green
        }
    }
}