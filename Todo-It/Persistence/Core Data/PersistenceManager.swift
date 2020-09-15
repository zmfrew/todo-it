import CoreData
import SwiftUI

final class PersistenceManager {
    private let notificationCenter: NotificationCenter
    private var willResignActiveNotification: NSObjectProtocol?
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Todo-It")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unexpected error: \(error)\n\(error.userInfo)")
            }
        }
        
        return container
    }()
    
    init(_ notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
        
        let notification = notificationCenter.addObserver(
            forName: UIApplication.willResignActiveNotification,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            guard let self = self else { return }
            
            if self.persistentContainer.viewContext.hasChanges {
                try? self.persistentContainer.viewContext.save()
            }
        }
        
        willResignActiveNotification = notification
    }
    // TODO: - Switch to use Combine here
    func fetchObjects(_ completion: ([Todo]) -> Void) {
        let moc = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CDTodo> = CDTodo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: true)]
        
        do {
            let cdTodos = try moc.fetch(fetchRequest)
            let todos = cdTodos.compactMap { $0.convert() }
            completion(todos)
        } catch {
            fatalError("Failed to fetch todos: \(error)")
        }
    }
    
    deinit {
        notificationCenter.removeObserver(willResignActiveNotification as Any)
    }
}
