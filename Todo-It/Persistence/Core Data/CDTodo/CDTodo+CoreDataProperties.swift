import CoreData
import Foundation

extension CDTodo {
    @NSManaged var createdDate: Date
    @NSManaged var dueDate: Date
    @NSManaged var title: String
    @NSManaged var isCompleted: Bool
    @NSManaged var id: UUID
}

extension CDTodo: Identifiable { }
