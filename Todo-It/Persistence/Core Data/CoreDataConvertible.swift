import CoreData

public protocol CoreDataConvertible: class {
    associatedtype ConvertibleType
    init(object: ConvertibleType, context: NSManagedObjectContext)
    func convert() -> ConvertibleType?
}
