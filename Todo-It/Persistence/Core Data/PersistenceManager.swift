import CoreData
import SwiftUI

final class PersistenceManager {
    private(set) var moc: NSManagedObjectContext
    private let notificationCenter: NotificationCenter
    private var willResignActiveNotification: NSObjectProtocol?
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Todo-It")
        container.loadPersistentStores { _, error in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

            if let error = error as NSError? {
                fatalError("Unexpected error: \(error)\n\(error.userInfo)")
            }
        }
        
        return container
    }()
    
    init(_ notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
        moc = persistentContainer.viewContext
        
        let notification = notificationCenter.addObserver(
            forName: UIApplication.willResignActiveNotification,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            guard let self = self else { return }
            
            if self.moc.hasChanges {
                try? self.moc.save()
            }
        }
        
        willResignActiveNotification = notification
    }
    
    func save(_ todos: [Todo], completion: (Result<Void, Error>) -> Void) {
        todos.forEach { CDTodo(object: $0, context: moc) }
        save(completion)
    }
    
    private func save(_ completion: (Result<Void, Error>) -> Void) {
        guard moc.hasChanges else {
            completion(.success(()))
            return
        }
        
        do {
            try moc.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    deinit {
        notificationCenter.removeObserver(willResignActiveNotification as Any)
    }
}
