//
//  AllRequestsView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//


import SwiftUI
import SwiftData

struct AllRequestsView: View {

    @ObservedObject var requestViewModel: RequestViewModel
    var user: User
    @Environment(\.modelContext) var context

    var body: some View {
        VStack(alignment: .leading) {

            Text("My Requests")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 12)

            if requestViewModel.borrowings.isEmpty {
                VStack {
                    Spacer()
                    Text("No requests found")
                        .foregroundColor(.gray)
                    Spacer()
                }
            } else {
                List(requestViewModel.borrowings) { borrowing in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(borrowing.room.building)
                            .font(.headline)

                        Text("Requested: \(borrowing.requestDate.formatted())")
                            .font(.caption)
                            .foregroundColor(.gray)

                        Text("Status: \(borrowing.statusApproval.rawValue)")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding()
        .navigationTitle("All Requests")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            requestViewModel.fetchAllBorrowings(
                context: context
            )
        }
    }
}
