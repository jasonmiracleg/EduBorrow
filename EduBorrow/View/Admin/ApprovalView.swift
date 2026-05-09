//
//  ApprovalView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftData
import SwiftUI

struct ApprovalView: View {

    @StateObject var viewModel = RequestViewModel()
    @Environment(\.modelContext) private var context
    @State private var alertMessage: String?
    @State private var showAlert = false

    @Query(sort: \Borrowing.requestDate, order: .reverse)
    private var allRequests: [Borrowing]

    var pendingRequests: [Borrowing] {
        allRequests.filter { $0.statusApproval == .pending }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {

                    if pendingRequests.isEmpty {
                        ContentUnavailableView(
                            "No Pending Approvals",
                            systemImage: "checkmark.seal",
                            description: Text(
                                "All requests have been processed."
                            )
                        )
                        .padding(.top, 40)
                    } else {
                        ForEach(pendingRequests) { request in
                            ApprovalCard(
                                request: request,
                                onApprove: {
                                    viewModel.approve(borrowing: request, context: context)

                                    alertMessage = viewModel.approvalMessage
                                    showAlert = true
                                },
                                onReject: {
                                    viewModel.reject(
                                        borrowing: request,
                                        context: context
                                    )

                                    alertMessage = "Request rejected"
                                    showAlert = true
                                }
                            )
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Approvals")
            .alert("Update", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage ?? "")
            }
        }
    }
}
