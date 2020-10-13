import SwiftUI

enum AppAction {
    case addList(_ title: String)
    case addTodo(dueDate: Date, title: String)
    case deleteLists(at: IndexSet)
    case deleteTodos(at: IndexSet)
    case edit(todo: Todo)
}
