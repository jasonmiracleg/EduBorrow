//
//  ApprovalView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI
import SwiftData

struct ApprovalView: View {

    @Environment(\.modelContext) private var context

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
                            description: Text("All requests have been processed.")
                        )
                        .padding(.top, 40)
                    } else {
                        ForEach(pendingRequests) { request in
                            ApprovalCard(request: request, context: context)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Approvals")
        }
    }
}
