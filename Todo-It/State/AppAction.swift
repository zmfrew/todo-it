import SwiftUI

enum AppAction {
    case addList(_ list: TodoList)
    case addTodo(_ todo: Todo)
    case deleteLists(at: IndexSet)
    case deleteTodos(at: IndexSet)
    case edit(todo: Todo)
}
