//
//  UserDetailView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//


import SwiftUI

struct UserDetailView: View {

    let user: User

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // MARK: Header Card
                VStack(spacing: 8) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.blue)

                    Text(user.name)
                        .font(.title2)
                        .bold()

                    Text(user.identityNumber)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(user.role.rawValue.capitalized)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.blue.opacity(0.2))
                        .foregroundStyle(.blue)
                        .clipShape(Capsule())
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                )

                // MARK: Info Section
                VStack(alignment: .leading, spacing: 12) {

                    InfoRow(title: "Phone Number", value: user.phoneNumber)
                    InfoRow(title: "Identity Number", value: user.identityNumber)
                    InfoRow(title: "Role", value: user.role.rawValue.capitalized)

                    InfoRow(title: "Total Borrowings", value: "\(user.borrowings.count)")
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

                Spacer()
            }
            .padding()
        }
        .navigationTitle("User Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}