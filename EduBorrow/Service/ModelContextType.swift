import Foundation
import SwiftData

// Protocol abstraction over SwiftData's ModelContext to make services testable
protocol ModelContextType {
    func insert<T: PersistentModel>(_ object: T)
    func delete<T: PersistentModel>(_ object: T)
    func save() throws
    func fetch<T: PersistentModel>(_ descriptor: FetchDescriptor<T>) throws -> [T]
}

extension ModelContext: ModelContextType {}


