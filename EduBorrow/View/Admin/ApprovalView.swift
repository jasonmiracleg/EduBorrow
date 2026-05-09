//
//  ApprovalView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI
struct ApprovalView: View {

    @State private var requests = [
        "Borrow Projector",
        "Request Room A",
        "Borrow Laptop"
    ]

    var body: some View {
        List {
            ForEach(requests, id: \.self) { request in
                VStack(alignment: .leading, spacing: 8) {
                    Text(request)
                        .font(.headline)

                    HStack {
                        Button("Approve") {
                            // handle approve
                        }
                        .buttonStyle(.borderedProminent)

                        Button("Reject") {
                            // handle reject
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                    }
                }
                .padding(.vertical, 6)
            }
        }
    }
}
