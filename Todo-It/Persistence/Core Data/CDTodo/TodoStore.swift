import Combine
import CoreData
// FIXME: - Refactor to support lists.
// FIXME: - Might not even need this as todos are tied to lists
final class TodoStore: NSObject, ObservableObject {
    @Published var todos: [Todo] = []
    private let frc: NSFetchedResultsController<CDTodo>
    
    init(managedObjectContext: NSManagedObjectContext) {
        frc = NSFetchedResultsController(
            fetchRequest: CDTodo.fetchByCreatedDate(),
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
            
            todos = frc.fetchedObjects?.compactMap { $0.convert() } ?? []
        } catch {
            print("Failed to fetch todos.")
        }
    }
    
    func add(_ todo: Todo) {
        guard !todos.contains(todo) else { return }
        
        todos.append(todo)
    }
    
    @discardableResult
    func delete(atOffsets offsets: IndexSet) -> [Todo] {
        let todosToDelete = offsets.map { todos[$0] }
        todos.remove(atOffsets: offsets)
        return todosToDelete
    }
    
    func edit(_ todo: Todo) {
        guard let index = todos.firstIndex(of: todo) else { return }
        
        todos[index] = todo
    }
}

extension TodoStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let todoItems = controller.fetchedObjects as? [CDTodo] else { return }

        todos = todoItems.compactMap { $0.convert() }
    }
}
