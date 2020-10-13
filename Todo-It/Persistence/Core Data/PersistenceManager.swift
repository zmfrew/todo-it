import Combine
import CoreData
import SwiftUI
// TODO: - Use Combine instead of callbacks.
enum ChangeType {
    case deleted, inserted, updated
    
    var userInfoKey: String {
        switch self {
        case .deleted: return NSDeletedObjectIDsKey
        case .inserted: return NSInsertedObjectIDsKey
        case .updated: return NSUpdatedObjectIDsKey
        }
    }
}

final class PersistenceManager {
    private let backgroundContext: NSManagedObjectContext
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
    
    init(_ notificationCenter: NotificationCenter = .default) {
        self.backgroundContext = persistentContainer.newBackgroundContext()
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
    
    func addList(_ title: String) {
        let list = TodoList(context: backgroundContext)
        list.id = UUID()
        list.title = title
        list.todos = NSOrderedSet(array: [])
        
        save { result in
            switch result {
            case .success:
                print("Successfully saved lists")
                
            case .failure(let error):
                print("Error occurred saving lists: \(error.localizedDescription)")
            }
        }
    }
    // TODO: - Try using generic functions
//    func delete<T: CoreDataSavable>(_ items: [T], completion: (Result<Void, Error>) -> Void) {
//        guard let cdItems = moc.registeredObjects as? Set<T> else {
//            completion(.failure(NSError(domain: "No registered objects", code: -1)))
//            return
//        }
//
//        let itemsToDelete = cdItems.filter { cdItem in
//            items.contains(where: { $0.id == cdItem.id })
//        }
//
//        itemsToDelete.forEach {
//            if let item = $0 as? NSManagedObject {
//                moc.delete(item)
//            }
//        }
//
//        save(completion)
//    }
    
    func delete(_ lists: [TodoList], completion: (Result<Void, Error>) -> Void) {
//        let cdLists = moc.registeredObjects.compactMap { $0 as? TodoList }
//
//        let listsToDelete = cdLists.filter { cdTodo in
//            lists.contains(where: { $0.id == cdTodo.id })
//        }
//
//        listsToDelete.forEach {
//            moc.delete($0)
//        }
        
        save(completion)
    }
    
    func delete(_ todos: [Todo], completion: (Result<Void, Error>) -> Void) {
//        let cdTodos = moc.registeredObjects.compactMap { $0 as? Todo }
//
//        let todosToDelete = cdTodos.filter { cdTodo in
//            todos.contains(where: { $0.id == cdTodo.id })
//        }
//
//        todosToDelete.forEach {
//            moc.delete($0)
//        }
        
        save(completion)
    }
    
    private func managedObject(
        with id: NSManagedObjectID,
        changeType: ChangeType,
        from notification: Notification,
        in context: NSManagedObjectContext
    ) -> NSManagedObject? {
        guard let objects = notification.userInfo?[changeType.userInfoKey] as? Set<NSManagedObjectID>,
              objects.contains(id) else { return nil }
        
        return context.object(with: id)
    }
    
    func publisher<T: NSManagedObject>(
        for managedObject: T,
        in context: NSManagedObjectContext,
        changeTypes: [ChangeType]
    ) -> AnyPublisher<(T?, ChangeType), Never> {
        let notification = NSManagedObjectContext.didMergeChangesObjectIDsNotification
        return notificationCenter.publisher(for: notification, object: context)
            .compactMap { notification in
                for type in changeTypes {
                    if let object = self.managedObject(
                        with: managedObject.objectID,
                        changeType: type,
                        from: notification,
                        in: context
                    ) as? T {
                        return (object, type)
                    }
                }
                
                return nil
            }
            .eraseToAnyPublisher()
    }
    
    func publisher<T: NSManagedObject>(
        for type: T.Type,
        in context: NSManagedObjectContext,
        changeTypes: [ChangeType]
    ) -> AnyPublisher<[([T], ChangeType)], Never> {
        let notification = NSManagedObjectContext.didMergeChangesObjectIDsNotification
        return NotificationCenter.default.publisher(for: notification, object: context)
            .compactMap({ notification in
                return changeTypes.compactMap({ type -> ([T], ChangeType)? in
                    guard let changes = notification.userInfo?[type.userInfoKey] as? Set<NSManagedObjectID> else {
                        return nil
                    }
                    
                    let objects = changes
                        .filter({ objectID in objectID.entity == T.entity() })
                        .compactMap({ objectID in context.object(with: objectID) as? T })
                    return (objects, type)
                })
            })
            .eraseToAnyPublisher()
    }

    private func save(_ completion: (Result<Void, Error>) -> Void) {
        guard backgroundContext.hasChanges else {
            completion(.success(()))
            return
        }
        
        do {
            try backgroundContext.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    deinit {
        notificationCenter.removeObserver(willResignActiveNotification as Any)
    }
}
