//
//  AllPendingRequestView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI
import SwiftData

struct AllPendingRequestsView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.modelContext) var context
    @ObservedObject var requestViewModel: RequestViewModel
    @State private var selectedBorrowing: Borrowing?
    @State private var showUpdateSheet: Bool = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(requestViewModel.pendingBorrowings) { borrowing in
                    PendingRequestDetailCard(borrowing: borrowing)
                    .contextMenu {
                            Button {
                                selectedBorrowing = borrowing
                                showUpdateSheet = true
                            } label: {
                                Label("Update", systemImage: "pencil")
                            }
                            
                            // MARK: Delete action
                            if viewModel.user != nil {
                                Button(role: .destructive) {
                                    requestViewModel.deleteBorrowing(
                                        borrowing: borrowing, user: viewModel.user!,
                                        context: context
                                    )
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationTitle("All Pending Requests")
        }
    }
}
