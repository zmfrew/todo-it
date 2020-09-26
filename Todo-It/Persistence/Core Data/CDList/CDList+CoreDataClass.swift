import Foundation
import CoreData

final class CDList: NSManagedObject { }

extension CDList {
    @nonobjc class func fetchByTitle() -> NSFetchRequest<CDList> {
        let request = NSFetchRequest<CDList>(entityName: String(describing: self))
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return request
    }
}

extension CDList: CoreDataConvertible {
    @discardableResult
    convenience init(object: TodoList, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = object.id
        self.title = object.title
        object.todos.forEach { addToTodos(CDTodo(object: $0, context: context)) }
    }
    
    func convert() -> TodoList? {
        let todos = self.todos.compactMap { ($0 as? CDTodo)?.convert() }
        
        return TodoList(
            id: self.id,
            title: self.title,
            todos: todos
        )
    }
}
