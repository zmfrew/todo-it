import Foundation

struct Todo: Identifiable, Hashable {
    // TODO: - Implement categories, dueDate, and lastUpdatedDate
    // var categories: [Category]
    let createdDate = Date()
    var description: String
//    let dueDate: Date
    var isCompleted = false // Default to false because a Todo should not be created if it's already completed.
    let id = UUID()
//    var lastUpdatedDate: Date
}
