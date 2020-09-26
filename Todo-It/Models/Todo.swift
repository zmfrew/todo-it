import Foundation

struct Todo: Hashable, Identifiable {
    // TODO: - Implement categories, dueDate, and lastUpdatedDate
    // var categories: [Category]
    let createdDate: Date
//    let dueDate: Date
    let id: UUID
    var isCompleted: Bool
//    var lastUpdatedDate: Date
    var title: String
}
