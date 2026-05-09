//
//  AuthenticationView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftData
import SwiftUI

struct AuthenticationView: View {

    @State private var isPasswordVisible = false
    @StateObject var viewModel: AuthenticationViewModel
    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // MARK: - Header
                VStack(spacing: 8) {
                    Text("EduBorrow")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Academic Equipment Inventory System")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                // MARK: - Form
                VStack(spacing: 16) {

                    // Identity Number
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Identity Number (NIM/NIK)")
                            .font(.headline)

                        TextField(
                            "Enter identity number",
                            text: $viewModel.identityNumber
                        )
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .keyboardType(.numberPad)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }

                    // Password
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.headline)

                        HStack {
                            if isPasswordVisible {
                                TextField(
                                    "Enter password",
                                    text: $viewModel.password
                                )
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                            } else {
                                SecureField(
                                    "Enter password",
                                    text: $viewModel.password
                                )
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                            }

                            Button {
                                isPasswordVisible.toggle()
                            } label: {
                                Image(
                                    systemName: isPasswordVisible
                                        ? "eye.slash.fill" : "eye.fill"
                                )
                                .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                }

                // MARK: - Login Button
                Button {
                    viewModel.login(context: context)
                } label: {
                    Text("Login")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.top, 8)

                // MARK: - Message
                Text(viewModel.loginMessage)
                    .foregroundColor(viewModel.isAuthenticated ? .green : .red)
            }
            .padding(24)
            .navigationDestination(isPresented: $viewModel.isAuthenticated) {
                ContentView()
            }
        }
    }
}

#Preview {
    AuthenticationView(viewModel: AuthenticationViewModel())
}
