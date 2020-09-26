import Foundation

struct TodoList: Hashable, Identifiable {
    let id: UUID
    let title: String
    var todos: [Todo]
}
