//
//  BorrowingTransactionView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI
import SwiftData

struct BorrowTransactionView: View {

    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = BorrowTransactionViewModel()

    @State private var showShareSheet = false

    var body: some View {
        NavigationStack {
            ScrollView {

                if viewModel.transactions.isEmpty {
                    emptyState
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.transactions) { trx in
                            BorrowTransactionCard(transaction: trx)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Transactions")
            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        ApprovalView()
                    } label: {
                        Image(systemName: "checkmark.seal")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.exportPDF()
                    } label: {
                        Image(systemName: "arrow.down.doc")
                    }
                }
            }
            .onAppear {
                viewModel.setContext(context)
                viewModel.fetchTransactions()
            }
            .sheet(isPresented: $viewModel.showShareSheet) {
                if let url = viewModel.shareURL {
                    ShareSheet(activityItems: [url])
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "arrow.2.circlepath")
                .font(.largeTitle)
                .foregroundStyle(.secondary)

            Text("No transactions yet")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 40)
    }
}
