//
//  CreateEquipmentView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI
import SwiftData

struct CreateEquipmentView: View {

    @State private var equipmentName: String = ""
    @State private var stock: String = ""
    @State private var category: Category = .other

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context

    @StateObject private var viewModel = EquipmentViewModel()

    var body: some View {
        Form {

            Section(header: Text("Equipment Info")) {

                TextField("Equipment Name", text: $equipmentName)

                TextField("Stock", text: $stock)
                    .keyboardType(.numberPad)

                Picker("Category", selection: $category) {
                    ForEach(Category.allCases, id: \.self) { cat in
                        Text(cat.rawValue).tag(cat)
                    }
                }
            }

            Section {
                Button("Save Equipment") {
                    saveEquipment()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Create Equipment")
    }

    private func saveEquipment() {
        guard let stockInt = Int(stock),
              !equipmentName.isEmpty else {
            return
        }

        viewModel.addEquipment(
            name: equipmentName,
            stock: stockInt,
            category: category,
            context: context
        )

        dismiss()
    }
}
