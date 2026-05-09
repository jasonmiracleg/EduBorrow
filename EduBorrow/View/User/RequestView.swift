//
//  RequestView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI
struct RequestView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @StateObject var requestViewModel: RequestViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("EduBorrow")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Room & Equipment Request")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "clock.fill")
                            .font(Font.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                    }
                }

                // Create Request Card
                if let user = viewModel.user {
                    ActionCard(
                        title: "Create Request",
                        description: "Borrow room or academic equipment easily.",
                        icon: "arrow.right.circle.fill",
                        color: .blue,
                        destination: CreateBorrowingView(
                            viewModel: requestViewModel,
                            currentUser: user
                        )
                    )
                }

                // Pending Approval
                VStack(alignment: .leading, spacing: 16) {

                    HStack {
                        Text("Pending Approval")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Spacer()

                        Button (action: {}) {
                            Text("See Pending Requests")
                                .font(.caption)
                        }
                    }

                    VStack(spacing: 16) {
                        if requestViewModel.pendingBorrowings.isEmpty {
                            Text("No pending requests")
                        } else {
                            List(requestViewModel.pendingBorrowings) { borrowing in
                                PendingRequestCard(
                                    roomName: borrowing.room.building,
                                    requestDate: borrowing.requestDate.formatted(),
                                    status: borrowing.statusApproval.rawValue
                                )
                            }
                            .listStyle(.plain)
                        }
                    }
                }
            }
            .padding(24)
        }
    }
}

#Preview {
    RequestView(requestViewModel: RequestViewModel())
}
