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
    func loadEquipment(context: ModelContextType) {
        equipments = service.fetchEquipment(context: context)
    }

    // MARK: - CREATE
    func addEquipment(
        name: String,
        stock: Int,
        category: Category,
        context: ModelContextType
    ) {

        let newId = generateEquipmentId(category: category, context: context)

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
            context: ModelContextType
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
    func deleteEquipment(equipment: Equipment, context: ModelContextType) {
        service.deleteEquipment(equipment: equipment, context: context)
        loadEquipment(context: context)
    }

    // MARK: - ID GENERATOR
    private func generateEquipmentId(category: Category, context: ModelContextType) -> String {

        let prefix = category.code

        let descriptor = FetchDescriptor<Equipment>(
            sortBy: [SortDescriptor(\.equipmentId, order: .reverse)]
        )

        let all = (try? context.fetch(descriptor)) ?? []

        let lastNumber = all
            .compactMap { equipment in
                let parts = equipment.equipmentId.split(separator: "-")
                return Int(parts.last ?? "")
            }
            .max() ?? 0

        let next = lastNumber + 1
        let formatted = String(format: "%03d", next)

        return "\(prefix)-\(formatted)"
    }
}
