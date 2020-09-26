import CoreData

public protocol CoreDataConvertible: class {
    associatedtype ConvertibleType
    init(object: ConvertibleType, context: NSManagedObjectContext)
    
    var id: UUID { get set }
    func convert() -> ConvertibleType?
}
