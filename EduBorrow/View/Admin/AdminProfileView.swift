//
//  AdminProfileView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI
struct AdminProfileView: View {

    let adminName: String = "Admin User"

    var body: some View {
        VStack(spacing: 20) {

            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.gray)

            Text(adminName)
                .font(.title2)
                .fontWeight(.semibold)

            Spacer()

            Button(role: .destructive) {
                // logout action
            } label: {
                Text("Logout")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .padding()
    }
}
