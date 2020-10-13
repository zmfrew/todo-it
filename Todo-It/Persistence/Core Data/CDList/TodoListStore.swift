import Combine
import CoreData

final class TodoListStore: NSObject, ObservableObject {
    @Published var lists: [TodoList] = []
    private var cancellables = Set<AnyCancellable>()
    private let manager: PersistenceManager
    private let frc: NSFetchedResultsController<TodoList>
    
    init(manager: PersistenceManager) {
        self.manager = manager
        frc = NSFetchedResultsController(
            fetchRequest: TodoList.fetchByTitle(),
            managedObjectContext: manager.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
            
            lists = frc.fetchedObjects ?? []
        } catch {
            print("Failed to fetch")
        }
//        manager.publisher(for: TodoList.Type, in: manager.persistentContainer.viewContext, changeTypes: [.deleted, .inserted, .updated])
//        manager.publisher(for: TodoList.Type, in: manager.persistentContainer.viewContext, changeTypes: [.deleted, .inserted, .updated])
//            .sink { _ in
//                manager.persistentContainer.viewContext.perform {
//                }
//            }
//            .store(in: &cancellables)
    }
}

extension TodoListStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let todoItems = controller.fetchedObjects as? [TodoList] else { return }

        lists = todoItems
    }
}
