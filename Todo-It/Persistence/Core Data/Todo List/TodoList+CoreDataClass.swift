import Foundation
import CoreData

final class TodoList: NSManagedObject { }

extension TodoList {
    @nonobjc class func fetchByTitle() -> NSFetchRequest<TodoList> {
        let request = NSFetchRequest<TodoList>(entityName: String(describing: self))
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return request
    }
}
