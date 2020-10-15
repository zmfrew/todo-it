import Foundation
import CoreData

extension TodoList {
    @NSManaged var title: String
    @NSManaged var id: UUID
    @NSManaged var todos: NSOrderedSet
}

extension TodoList {
    @objc(addTodosObject:)
    @NSManaged public func addToTodos(_ value: Todo)

    @objc(removeTodosObject:)
    @NSManaged public func removeFromTodos(_ value: Todo)

    @objc(addTodos:)
    @NSManaged public func addToTodos(_ values: NSOrderedSet)

    @objc(removeTodos:)
    @NSManaged public func removeFromTodos(_ values: NSOrderedSet)

}

extension TodoList: Identifiable { }
