//
//  CreateEquipmentView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI

struct CreateEquipmentView: View {

    @State private var equipmentName: String = ""
    @State private var stock: String = ""
    @State private var category: Category = .other

    @Environment(\.dismiss) var dismiss

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
        guard let stockInt = Int(stock), !equipmentName.isEmpty else {
            return
        }

        let newEquipment = Equipment(
            equipmentId: UUID().uuidString,
            equipmentName: equipmentName,
            stock: stockInt,
            category: category
        )

        // TODO: insert into SwiftData / ViewModel
        print("Saved:", newEquipment)

        dismiss()
    }
}
