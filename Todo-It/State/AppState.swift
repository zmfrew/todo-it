import Combine
import CoreData

struct AppState {
    private var cancellables: Set<AnyCancellable> = []
    private let persistenceManager: PersistenceManager
    var todoStore: TodoStore
    
    init(_ persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
        self.todoStore = TodoStore(managedObjectContext: persistenceManager.moc)
    }
    
    func delete(_ todos: [Todo]) {
        persistenceManager.delete(todos) { result in
            switch result {
            case .success:
                print("Deleted successfully")
                
            case .failure(let error):
                print("Error occurred deleting: \(error.localizedDescription)")
            }
        }
    }
        
    func save() {
        persistenceManager.save(todoStore.todos) { result in
            switch result {
            case .success:
                print("Saved successfully")
                
            case .failure(let error):
                print("Error occurred saving: \(error.localizedDescription)")
            }
        }
    }
}
