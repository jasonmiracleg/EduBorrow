//
//  UserFormView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//


import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct UserFormView: View {

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @StateObject private var vm = UserViewModel()

    var userToEdit: User?

    @State private var identityNumber = ""
    @State private var name = ""
    @State private var phoneNumber = ""
    @State private var role: Role = .student

    var isEdit: Bool {
        userToEdit != nil
    }

    var body: some View {
        NavigationStack {
            Form {

                Section("User Info") {
                    TextField("Identity Number", text: $identityNumber)
                    TextField("Name", text: $name)
                    TextField("Phone Number", text: $phoneNumber)

                    Picker("Role", selection: $role) {
                        ForEach(Role.allCases, id: \.self) { r in
                            Text(r.rawValue).tag(r)
                        }
                    }
                }

                if !isEdit {
                    Section {
                        Text("Default password: \(name + "123")")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle(isEdit ? "Edit User" : "Add User")
            .toolbar {

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(isEdit ? "Update" : "Save") {
                        isEdit ? vm.updateUser(user: userToEdit!, identityNumber: identityNumber, name: name, phoneNumber: phoneNumber, role: role, context: context) : vm.createUser(identityNumber: identityNumber, name: name, phoneNumber: phoneNumber, role: role, context: context)
                        dismiss()
                    }
                    .disabled(name.isEmpty || identityNumber.isEmpty)
                }
            }
            .onAppear {
                vm.loadUsers(context: context)

                if let user = userToEdit {
                    identityNumber = user.identityNumber
                    name = user.name
                    phoneNumber = user.phoneNumber
                    role = user.role
                }
            }
        }
    }
}
