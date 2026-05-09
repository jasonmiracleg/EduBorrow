//
//  UserProfileView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI
struct UserProfileView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {

                // MARK: - Header Card
                VStack(spacing: 16) {

                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)

                    VStack(spacing: 6) {

                        Text(viewModel.user?.name ?? "Unknown")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text(viewModel.user?.role.rawValue ?? "Unknown")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 28)
                .background(.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )

                // MARK: - Information Section
                VStack(alignment: .leading, spacing: 20) {

                    Text("Personal Information")
                        .font(.headline)

                    VStack(spacing: 18) {
                        ProfileInfoRow(
                            title: "Identity Number",
                            value: viewModel.user?.identityNumber ?? "Unknown"
                        )

                        Divider()


                        ProfileInfoRow(
                            title: "Phone Number",
                            value: viewModel.user?.phoneNumber ?? "Unknown"
                        )
                    }
                }
                .padding(20)
                .background(.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )

                // MARK: - Logout Button
                Button {
                    viewModel.logout()
                } label: {
                    HStack {
                        Spacer()

                        Text("Logout")
                            .fontWeight(.semibold)

                        Spacer()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(14)
                }
            }
            .padding(20)
        }
    }
}
