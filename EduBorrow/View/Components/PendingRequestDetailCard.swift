//
//  PendingRequestDetailCard.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI

struct PendingRequestDetailCard: View {

    let borrowing: Borrowing

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // MARK: Status Row
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.orange)

                Text(borrowing.statusApproval.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.orange)

                Spacer()
            }

            // MARK: Room Info
            Text(borrowing.room.building)
                .font(.headline)

            Text("Request Date: \(borrowing.requestDate.formatted())")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text("Usage Date: \(borrowing.usageDate.formatted())")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text("Duration: \(borrowing.durationInHours) hour(s)")
                .font(.subheadline)
                .foregroundColor(.gray)

            Divider()

            // MARK: Purpose
            VStack(alignment: .leading, spacing: 4) {
                Text("Purpose")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(borrowing.purpose)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }

            Divider()

            // MARK: Equipment Section
            VStack(alignment: .leading, spacing: 6) {

                Text("Equipments")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                if borrowing.equipmentList.isEmpty {
                    Text("No equipments selected")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    ForEach(borrowing.equipmentList, id: \.self) { item in
                        HStack(alignment: .top) {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 6))
                                .foregroundColor(.gray)
                                .padding(.top, 6)

                            Text(item)
                                .font(.subheadline)
                        }
                    }
                }
            }
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
