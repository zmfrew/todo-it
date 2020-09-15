import Combine

struct AppState {
    private let persistenceManager: PersistenceManager
    private let todoStorage: TodoStorage
    var todos: [Todo] = []
    
    init(_ persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
        self.todoStorage = TodoStorage(managedObjectContext: persistenceManager.persistentContainer.viewContext)
        todos = todoStorage.todos
    }
}
