import Combine
import CoreData

struct AppState {
    private var cancellables: Set<AnyCancellable> = []
    private let persistenceManager: PersistenceManager
    var listStore: TodoListStore
    var todoStore: TodoStore
    
    init(_ persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
        self.listStore = TodoListStore(managedObjectContext: persistenceManager.moc)
        self.todoStore = TodoStore(managedObjectContext: persistenceManager.moc)
    }
    
    func deleteLists(_ lists: [TodoList]) {
        persistenceManager.delete(lists) { result in
            switch result {
            case .success:
                print("Successfully deleted lists")
                
            case .failure(let error):
                print("Error occurred deleting lists: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteTodos(_ todos: [Todo]) {
        persistenceManager.delete(todos) { result in
            switch result {
            case .success:
                print("Successfully deleted todos")
                
            case .failure(let error):
                print("Error occurred deleting todos: \(error.localizedDescription)")
            }
        }
    }
        
    func saveLists() {
        persistenceManager.save(listStore.lists) { result in
            switch result {
            case .success:
                print("Saved lists successfully")
                
            case .failure(let error):
                print("Error occurred saving lists: \(error.localizedDescription)")
            }
        }
    }
    
    func saveTodos() {
        persistenceManager.save(todoStore.todos) { result in
            switch result {
            case .success:
                print("Saved todos successfully")
                
            case .failure(let error):
                print("Error occurred saving todos: \(error.localizedDescription)")
            }
        }
    }
}
