//
//  AdminTabView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI

struct AdminTabView: View {
    var body: some View {
        TabView {
            // MARK: - 1. Properties
            PropertiesView()
                .tabItem {
                    Label("Properties", systemImage: "house.fill")
                }

            // MARK: - 2. Approval
            ApprovalView()
                .tabItem {
                    Label("Approval", systemImage: "checkmark.seal.fill")
                }

            // MARK: - 3. Users
            UsersView()
                .tabItem {
                    Label("Users", systemImage: "person.3.fill")
                }
        }
    }
}
