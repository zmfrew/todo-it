import Foundation
import CoreData

@objc(Todo)
final class CDTodo: NSManagedObject {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CDTodo> {
        NSFetchRequest<CDTodo>(entityName: String(describing: self))
    }
}

extension CDTodo: CoreDataConvertible {
    @discardableResult
    convenience init(object: Todo, context: NSManagedObjectContext) {
        self.init(context: context)
        self.createdDate = object.createdDate
        self.id = object.id
        self.isCompleted = object.isCompleted
        self.title = object.title
    }
    
    func convert() -> Todo? {
        Todo(
            createdDate: self.createdDate,
            id: self.id,
            isCompleted: self.isCompleted,
            title: self.title
        )
    }
}
