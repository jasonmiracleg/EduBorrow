//
//  BorrowTransactionViewModel.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//


import SwiftUI
import SwiftData
import Combine

@MainActor
final class BorrowTransactionViewModel: ObservableObject {

    @Published var transactions: [Borrowing] = []
    @Published var shareURL: URL?
    @Published var showShareSheet = false
    @Published var isExporting = false
    @Published var errorMessage: String?

    private let pdfService = PDFService()
    private var context: ModelContext?

    func setContext(_ context: ModelContext) {
        self.context = context
    }

    func fetchTransactions() {
        guard let context else { return }

        do {
            let descriptor = FetchDescriptor<Borrowing>(
                sortBy: [SortDescriptor(\.usageDate, order: .reverse)]
            )
            transactions = try context.fetch(descriptor)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func exportPDF() {
        do {
            let data = try pdfService.generateTransactionReport(transactions: transactions)

            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("Borrowing Transaction Report.pdf")

            try data.write(to: url)

            DispatchQueue.main.async {
                self.shareURL = url
                self.showShareSheet = true
            }

        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
