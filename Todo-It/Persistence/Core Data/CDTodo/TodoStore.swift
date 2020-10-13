import Combine
import CoreData
// FIXME: - Refactor to support lists.
// FIXME: - Might not even need this as todos are tied to lists
final class TodoStore: NSObject, ObservableObject {
    @Published var todos: [Todo] = []
    private let frc: NSFetchedResultsController<Todo>
    
    init(managedObjectContext: NSManagedObjectContext) {
        frc = NSFetchedResultsController(
            fetchRequest: Todo.fetchByCreatedDate(),
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
            
            todos = frc.fetchedObjects ?? []
        } catch {
            print("Failed to fetch todos.")
        }
    }
}

extension TodoStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let todoItems = controller.fetchedObjects as? [Todo] else { return }

        todos = todoItems
    }
}
