//
//  FakeModelContext.swift
//  EduBorrow
//
//  Created by Jason Miracle Gunawan on 10/05/26.
//


import SwiftData
import XCTest
@testable import EduBorrow

final class FakeModelContext: ModelContextType {

    var storage: [Any] = []

    func insert<T: PersistentModel>(_ object: T) {
        storage.append(object)
    }

    func delete<T: PersistentModel>(_ object: T) {
        storage.removeAll { $0 as AnyObject === (object as AnyObject) }
    }

    func save() throws {}

    func fetch<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) throws -> [T] {
        storage.compactMap { $0 as? T }
    }
}
