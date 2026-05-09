//
//  PendingRequestCard.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI
struct PendingRequestCard: View {

    let roomName: String
    let requestDate: String
    let status: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.orange)

                Text(status)
                    .font(.subheadline)
                    .foregroundColor(.orange)

                Spacer()
            }

            Text(roomName)
                .font(.headline)

            Text("Request Date: \(requestDate)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}
