//
//  DashboardView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI

struct DashboardView: View {

    @State private var selectedTab: Tab = .request
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @ObservedObject private var requestViewModel: RequestViewModel = RequestViewModel()

    enum Tab {
        case request
        case profile
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TabView {
                    RequestView(requestViewModel: requestViewModel)
                        .tabItem {
                            Label("Request", systemImage: "doc.text.fill")
                        }

                    UserProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person.crop.circle.fill")
                        }
                }
                .tint(.blue)
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    DashboardView()
}
