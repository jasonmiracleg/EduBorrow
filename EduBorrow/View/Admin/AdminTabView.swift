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

            // MARK: - 2. Transactions (Borrowing)
            BorrowTransactionView()
                .tabItem {
                    Label("Transactions", systemImage: "arrow.2.circlepath")
                }

            // MARK: - 3. Users
            UsersView()
                .tabItem {
                    Label("Users", systemImage: "person.3.fill")
                }
        }
    }
}
