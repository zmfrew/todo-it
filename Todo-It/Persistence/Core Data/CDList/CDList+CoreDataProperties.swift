import Foundation
import CoreData

extension CDList {
    @NSManaged var title: String
    @NSManaged var id: UUID
    @NSManaged var todos: NSOrderedSet
}

extension CDList {
    @objc(addTodosObject:)
    @NSManaged public func addToTodos(_ value: CDTodo)

    @objc(removeTodosObject:)
    @NSManaged public func removeFromTodos(_ value: CDTodo)

    @objc(addTodos:)
    @NSManaged public func addToTodos(_ values: NSOrderedSet)

    @objc(removeTodos:)
    @NSManaged public func removeFromTodos(_ values: NSOrderedSet)

}

extension CDList: Identifiable { }
