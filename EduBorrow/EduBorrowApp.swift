//
//  EduBorrowApp.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftData
import SwiftUI

@main
struct EduBorrowApp: App {
    @StateObject private var authViewModel =
        AuthenticationViewModel()

    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                ContentView()
            } else {
                AuthenticationView(
                    viewModel: authViewModel
                )
                .onAppear {
                    do {
                        let container = try ModelContainer(
                            for:
                                User.self,
                            Room.self,
                            Equipment.self,
                            Borrowing.self,
                            BorrowingEquipment.self
                        )

                        let context = ModelContext(container)

                        SeederService.seedUsers(
                            context: context
                        )
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .modelContainer(for: [
            User.self,
            Room.self,
            Equipment.self,
            Borrowing.self,
            BorrowingEquipment.self,
        ])
    }
}
