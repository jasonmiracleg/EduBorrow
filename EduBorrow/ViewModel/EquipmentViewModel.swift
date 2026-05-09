//
//  EquipmentViewModel.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import Foundation
import Combine
import SwiftData

@MainActor
final class EquipmentViewModel: ObservableObject {

    @Published var equipments: [Equipment] = []

    private let service = EquipmentService()

    // MARK: - LOAD
    func loadEquipment(context: ModelContext) {
        equipments = service.fetchEquipment(context: context)
    }

    // MARK: - CREATE
    func addEquipment(
        name: String,
        stock: Int,
        category: Category,
        context: ModelContext
    ) {

        let newId = generateEquipmentId(category: category)

        service.createEquipment(
            equipmentId: newId,
            name: name,
            stock: stock,
            category: category,
            context: context
        )

        loadEquipment(context: context)
    }

    // MARK: - UPDATE
    func updateEquipment(
        equipment: Equipment,
        name: String,
        stock: Int,
        category: Category,
        context: ModelContext
    ) {
        service.updateEquipment(
            equipment: equipment,
            name: name,
            stock: stock,
            category: category,
            context: context
        )

        loadEquipment(context: context)
    }

    // MARK: - DELETE
    func deleteEquipment(equipment: Equipment, context: ModelContext) {
        service.deleteEquipment(equipment: equipment, context: context)
        loadEquipment(context: context)
    }

    // MARK: - ID GENERATOR
    private func generateEquipmentId(category: Category) -> String {

        let prefix = category.code

        // simple unique number based on timestamp
        let number = (equipments.count + 1)
        let formatted = String(format: "%03d", number)

        return "\(prefix)-\(formatted)"

    }
}
