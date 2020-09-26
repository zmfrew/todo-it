import Combine
import CoreData

final class TodoListStore: NSObject, ObservableObject {
    @Published var lists: [TodoList] = []
    private let frc: NSFetchedResultsController<CDList>
    
    init(managedObjectContext: NSManagedObjectContext) {
        frc = NSFetchedResultsController(
            fetchRequest: CDList.fetchByTitle(),
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
            
            lists = frc.fetchedObjects?.compactMap { $0.convert() } ?? []
        } catch {
            print("Failed to fetch lists.")
        }
    }
    
    func add(_ list: TodoList) {
        guard !lists.contains(list) else { return }
        
        lists.append(list)
    }
    
    @discardableResult
    func delete(atOffsets offsets: IndexSet) -> [TodoList] {
        let listsToDelete = offsets.map { lists[$0] }
        lists.remove(atOffsets: offsets)
        return listsToDelete
    }
    
    func edit(_ list: TodoList) {
        guard let index = lists.firstIndex(of: list) else { return }
        
        lists[index] = list
    }
}

extension TodoListStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let todoItems = controller.fetchedObjects as? [CDList] else { return }

        lists = todoItems.compactMap { $0.convert() }
    }
}
