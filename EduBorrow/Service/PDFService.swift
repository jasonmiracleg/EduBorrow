//
//  PDFService.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import Foundation
import TPPDF
import UIKit

final class PDFService {

    func generateTransactionReport(transactions: [Borrowing]) throws -> Data {

        let document = PDFDocument(format: .a4)

        document.set(.contentLeft, font: UIFont.boldSystemFont(ofSize: 20))
        document.add(text: "Borrowing Transaction Report")
        document.resetFont(.contentLeft)

        document.add(space: 20)

        let table = PDFTable(size: (rows: transactions.count + 1, columns: 9))

        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        table[0, 0] = PDFTableCell(content: try? PDFTableContent(content: "User"))
        table[0, 1] = PDFTableCell(content: try? PDFTableContent(content: "Room"))
        table[0, 2] = PDFTableCell(content: try? PDFTableContent(content: "Purpose"))
        table[0, 3] = PDFTableCell(content: try? PDFTableContent(content: "Request"))
        table[0, 4] = PDFTableCell(content: try? PDFTableContent(content: "Usage"))
        table[0, 5] = PDFTableCell(content: try? PDFTableContent(content: "Duration"))
        table[0, 6] = PDFTableCell(content: try? PDFTableContent(content: "Status"))
        table[0, 7] = PDFTableCell(content: try? PDFTableContent(content: "Equipment Summary"))
        table[0, 8] = PDFTableCell(content: try? PDFTableContent(content: "Return Date"))

        for (index, trx) in transactions.enumerated() {
            let row = index + 1

            table[row, 0] = PDFTableCell(content: try? PDFTableContent(content: trx.user.name))
            table[row, 1] = PDFTableCell(content: try? PDFTableContent(content: trx.room.roomName))
            table[row, 2] = PDFTableCell(content: try? PDFTableContent(content: trx.purpose))
            table[row, 3] = PDFTableCell(content: try? PDFTableContent(content: formatter.string(from: trx.requestDate)))
            table[row, 4] = PDFTableCell(content: try? PDFTableContent(content: formatter.string(from: trx.usageDate)))
            table[row, 5] = PDFTableCell(content: try? PDFTableContent(content: "\(trx.durationInHours) hrs"))
            table[row, 6] = PDFTableCell(content: try? PDFTableContent(content: trx.statusApproval.rawValue))
            table[row, 7] = PDFTableCell(
                content: try? PDFTableContent(content: equipmentSummary(for: trx))
            )
            table[row, 8] = PDFTableCell(content: try? PDFTableContent(content: trx.returnTime.map { formatter.string(from: $0) } ?? "-"))
        }

        document.add(table: table)

        let generator = PDFGenerator(document: document)
        return try generator.generateData()
    }
    
    private func equipmentSummary(for borrowing: Borrowing) -> String {
        borrowing.borrowedEquipments
            .map { "\($0.equipment.equipmentName) x\($0.quantity)" }
            .joined(separator: ", ")
    }
}
