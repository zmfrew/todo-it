import CoreData
import Foundation

extension CDTodo {
    @NSManaged public var createdDate: Date
    @NSManaged public var title: String
    @NSManaged public var isCompleted: Bool
    @NSManaged public var id: UUID
}

extension CDTodo: Identifiable { }
