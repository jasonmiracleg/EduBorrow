//
//  PropertyCard.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI

struct PropertyCard: View {

    let title: String
    let subtitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text(title)
                .font(.headline)
                .lineLimit(1)

            if let subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(width: 160, height: 100, alignment: .leading)
        .background(Color.blue.opacity(0.15))
        .cornerRadius(12)
    }
}
