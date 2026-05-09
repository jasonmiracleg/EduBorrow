//
//  UsersView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//


import SwiftUI
import SwiftData

struct UsersView: View {

    @Environment(\.modelContext) private var modelContext

    @StateObject private var viewModel = UserViewModel()

    @State private var activeSheet: UserSheet?

    var body: some View {
        NavigationStack {
            VStack {

                ScrollView {

                    if viewModel.users.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "person.3")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)

                            Text("No users available")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)

                    } else {
                        LazyVStack(spacing: 16) {

                            ForEach(viewModel.users) { user in

                                NavigationLink {
                                    UserDetailView(user: user)
                                } label: {
                                    UserCard(
                                        name: user.name,
                                        identityNumber: user.identityNumber,
                                        role: user.role.rawValue
                                    )
                                }
                                .buttonStyle(.plain)
                                .contextMenu {

                                    Button {
                                        activeSheet = .edit(user)
                                    } label: {
                                        Label("Update", systemImage: "pencil")
                                    }

                                    Button(role: .destructive) {
                                        viewModel.deleteUser(user: user, context: modelContext)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        activeSheet = .add
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .add:
                    UserFormView()

                case .edit(let user):
                    UserFormView(userToEdit: user)
                }
            }
            .onAppear {
                viewModel.loadUsers(context: modelContext)
            }
        }
    }
}

enum UserSheet: Identifiable {
    case add
    case edit(User)

    var id: String {
        switch self {
        case .add:
            return "add"
        case .edit(let user):
            return user.userId.uuidString
        }
    }
}
