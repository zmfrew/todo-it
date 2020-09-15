import Combine
import CoreData
import SwiftUI

final class TodoStorage: NSObject, ObservableObject {
    @Published var todos: [Todo] = []
    private let frc: NSFetchedResultsController<CDTodo>
    
    init(managedObjectContext: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<CDTodo> = CDTodo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: true)]
        frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil, cacheName: nil
        )
        
        super.init()
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
            let newTodos = frc.fetchedObjects?.compactMap { $0.convert() } ?? []
            todos = newTodos
        } catch {
            print("failed to fetch items!")
        }
    }
}

extension TodoStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let fetchedTodos = controller.fetchedObjects as? [CDTodo] else { return }
        
        let newTodos = fetchedTodos.compactMap { $0.convert() }
        todos = newTodos
    }
}
