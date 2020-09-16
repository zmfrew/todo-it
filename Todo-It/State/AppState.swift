import CoreData

struct AppState {
    private let persistenceManager: PersistenceManager
    var todos: [Todo] = []
    
    init(_ persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
    }
    
    mutating func fetch() {
        let fetchRequest: NSFetchRequest<CDTodo> = CDTodo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: true)]
        
        do {
            let cdTodos = try persistenceManager.persistentContainer.viewContext.fetch(fetchRequest)
            let newTodos = cdTodos.compactMap { $0.convert() }
            todos = newTodos
        } catch {
            print("failed to fetch items!")
        }
    }
    
    func save() {
        persistenceManager.save(todos) { result in
            switch result {
            case .success:
                print("Saved successfully")
                
            case .failure(let error):
                print("Error occurred saving: \(error.localizedDescription)")
            }
        }
    }
}
