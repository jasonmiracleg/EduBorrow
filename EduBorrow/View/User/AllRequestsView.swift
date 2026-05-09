//
//  AllRequestsView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftData
import SwiftUI

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

                        // MARK: FINISH BUTTON (CONDITIONAL)
                        if shouldShowFinishButton(for: borrowing) {

                            Button {
                                requestViewModel.finishBorrowing(
                                    borrowing: borrowing,
                                    context: context
                                )
                            } label: {
                                Text("Finish")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.green)
                                    .cornerRadius(8)
                            }
                            .padding(.top, 4)
                        }
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

private func shouldShowFinishButton(for borrowing: Borrowing) -> Bool {

    let calendar = Calendar.current

    let isToday = calendar.isDate(
        borrowing.usageDate,
        inSameDayAs: Date()
    )

    let isApproved = borrowing.statusApproval == .approved

    return isToday && isApproved
}
