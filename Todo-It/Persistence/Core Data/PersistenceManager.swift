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
    
    func save(_ todos: [Todo], completion: (Result<Void, Error>) -> Void) {
        guard !todos.isEmpty else {
            completion(.success(()))
            return
        }
        
        let context = persistentContainer.viewContext
        
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        todos.forEach { CDTodo(object: $0, context: context) }
        
        guard context.hasChanges else {
            completion(.success(()))
            return
        }
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    deinit {
        notificationCenter.removeObserver(willResignActiveNotification as Any)
    }
}
