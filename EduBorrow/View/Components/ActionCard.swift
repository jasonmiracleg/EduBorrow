//
//  ActionCard.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI

struct ActionCard<Destination: View>: View {

    let title: String
    let description: String
    let icon: String
    let color: Color
    let destination: Destination

    var body: some View {
        NavigationLink {
            destination
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 8) {

                    Text(title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(color)
            .cornerRadius(12)
        }
    }
}
