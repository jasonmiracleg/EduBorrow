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
            if requestViewModel.pendingBorrowings.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.seal")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)

                    Text("No Pending Requests")
                        .font(.headline)

                    Text("All borrow requests have been processed.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(requestViewModel.pendingBorrowings) { borrowing in
                            PendingRequestDetailCard(borrowing: borrowing)
                                .contextMenu {
                                    Button {
                                        selectedBorrowing = borrowing
                                        showUpdateSheet = true
                                    } label: {
                                        Label("Update", systemImage: "pencil")
                                    }

                                    if viewModel.user != nil {
                                        Button(role: .destructive) {
                                            requestViewModel.deleteBorrowing(
                                                borrowing: borrowing,
                                                user: viewModel.user!,
                                                context: context
                                            )
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.vertical, 8)
                }
                .navigationTitle("All Pending Requests")
                .sheet(item: $selectedBorrowing) { borrowing in
                    UpdateBorrowingView(viewModel: requestViewModel, borrowing: borrowing)
                }
            }
        }
    }
}
