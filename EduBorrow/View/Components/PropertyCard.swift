//
//  PropertyCard.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI
struct PropertyCard: View {
    let title: String

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding()
        }
        .frame(width: 140, height: 100)
        .background(Color.blue.opacity(0.15))
        .cornerRadius(12)
    }
}
