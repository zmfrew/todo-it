import CoreData

public protocol CoreDataConvertible: class {
    associatedtype ConvertibleType
    func convert() -> ConvertibleType?
    init(object: ConvertibleType, context: NSManagedObjectContext)
}
