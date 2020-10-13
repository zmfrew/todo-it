import Combine
import CoreData

struct AppState {
    private var cancellables: Set<AnyCancellable> = []
    private let persistenceManager: PersistenceManager
    var listStore: TodoListStore
    var todoStore: TodoStore
    
    init(_ persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
        self.listStore = TodoListStore(manager: persistenceManager)
        self.todoStore = TodoStore(managedObjectContext: persistenceManager.moc)
    }
    
    func addList(_ title: String) {
        persistenceManager.addList(title)
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
}
