import Foundation
import CoreData

final class Todo: NSManagedObject { }

extension Todo {
    @nonobjc class func fetchByCreatedDate() -> NSFetchRequest<Todo> {
        let request = NSFetchRequest<Todo>(entityName: String(describing: self))
        request.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: true)]
        return request
    }
}
