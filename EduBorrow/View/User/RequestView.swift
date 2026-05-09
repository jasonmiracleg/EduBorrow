//
//  RequestView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftData
import SwiftUI

struct RequestView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @StateObject var requestViewModel: RequestViewModel
    @Environment(\.modelContext) var context

    var body: some View {
        NavigationStack {
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
                        
                        NavigationLink {
                            AllPendingRequestsView(requestViewModel: requestViewModel)
                        } label: {
                            Text("See Pending Requests")
                                .font(.caption)
                        }
                    }
                    
                    VStack(spacing: 16) {
                        if requestViewModel.pendingBorrowings.isEmpty {
                            Text("No pending requests")
                        } else {
                            LazyVStack(spacing: 16) {
                                ForEach(requestViewModel.recentPendingBorrowings) { borrowing in
                                    PendingRequestCard(
                                        roomName: borrowing.room.building,
                                        requestDate: borrowing.requestDate.formatted(),
                                        status: borrowing.statusApproval.rawValue
                                    )
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(24)
            .task {
                if let user = viewModel.user {
                    requestViewModel.fetchPendingRequests(
                        user: user,
                        context: context
                    )
                }
            }
        }
    }
}

#Preview {
    RequestView(requestViewModel: RequestViewModel())
}
