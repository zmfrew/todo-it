struct AppState {
    private let persistenceManager: PersistenceManager
    var todos: [Todo] = [
        Todo(title: "Walk the dog"),
        Todo(title: "Go for a bike ride"),
        Todo(title: "Do the laundry"),
        Todo(title: "Meal prep"),
        Todo(title: "Start Todo app")
    ]
    
    init(_ persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
        persistenceManager.fetchObjects { todos in
            self.todos = todos
        }
    }
}
