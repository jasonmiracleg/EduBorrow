//
//  UpdateEquipmentView.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftUI
import SwiftData

struct UpdateEquipmentView: View {

    var equipment: Equipment

    @State private var equipmentName: String
    @State private var stock: String
    @State private var category: Category

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context

    @StateObject private var viewModel = EquipmentViewModel()

    init(equipment: Equipment) {
        self.equipment = equipment
        _equipmentName = State(initialValue: equipment.equipmentName)
        _stock = State(initialValue: "\(equipment.stock)")
        _category = State(initialValue: equipment.category)
    }

    var body: some View {
        NavigationStack {
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
                    Button("Update Equipment") {
                        viewModel.updateEquipment(equipment: equipment, name: equipmentName, stock: Int(stock)!, category: category, context: context)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("Update Equipment")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var isFormValid: Bool {
        guard let stockInt = Int(stock) else { return false }
        
        return !equipmentName.trimmingCharacters(in: .whitespaces).isEmpty
            && stockInt > 0
    }
}
