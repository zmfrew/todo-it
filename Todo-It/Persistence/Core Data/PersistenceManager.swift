import CoreData
import SwiftUI

protocol CoreDataSavable: CoreDataConvertible, Identifiable, Hashable { }

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
        let cdLists = moc.registeredObjects.compactMap { $0 as? CDList }
        
        let listsToDelete = cdLists.filter { cdTodo in
            lists.contains(where: { $0.id == cdTodo.id })
        }
        
        listsToDelete.forEach {
            moc.delete($0)
        }
        
        save(completion)
    }
    
    func delete(_ todos: [Todo], completion: (Result<Void, Error>) -> Void) {
        let cdTodos = moc.registeredObjects.compactMap { $0 as? CDTodo }

        let todosToDelete = cdTodos.filter { cdTodo in
            todos.contains(where: { $0.id == cdTodo.id })
        }
        
        todosToDelete.forEach {
            moc.delete($0)
        }
        
        save(completion)
    }
    
//    func save<T: CoreDataSavable>(_ items: [T], completion: (Result<Void, Error>) -> Void) {
//        items.forEach {
//            guard let convertibleType = $0 as? T.ConvertibleType else { return }
//
//            _ = T(object: convertibleType, context: moc)
//        }
//        save(completion)
//    }
    
    func save(_ lists: [TodoList], completion: (Result<Void, Error>) -> Void) {
        lists.forEach { CDList(object: $0, context: moc) }
        save(completion)
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
