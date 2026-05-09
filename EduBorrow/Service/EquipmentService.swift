//
//  EquipmentService.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 09/05/26.
//

import SwiftData
import Foundation

final class EquipmentService {

    // CREATE
    func createEquipment(
        equipmentId: String,
        name: String,
        stock: Int,
        category: Category,
        context: ModelContext
    ) {
        let equipment = Equipment(
            equipmentId: equipmentId,
            equipmentName: name,
            stock: stock,
            category: category
        )

        context.insert(equipment)
        save(context: context)
    }

    // READ
    func fetchEquipment(context: ModelContext) -> [Equipment] {
        let descriptor = FetchDescriptor<Equipment>()
        return (try? context.fetch(descriptor)) ?? []
    }

    // UPDATE
    func updateEquipment(
        equipment: Equipment,
        name: String,
        stock: Int,
        category: Category,
        context: ModelContext
    ) {
        equipment.equipmentName = name
        equipment.stock = stock
        equipment.category = category

        save(context: context)
    }

    // DELETE
    func deleteEquipment(equipment: Equipment, context: ModelContext) {
        context.delete(equipment)
        save(context: context)
    }

    // MARK: - Private
    private func save(context: ModelContext) {
        do {
            try context.save()
        } catch {
            print("EquipmentService Save Error: \(error)")
        }
    }
}
