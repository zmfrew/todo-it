import SwiftUI

enum AppAction {
    case add(todo: Todo)
    case delete(at: IndexSet)
    case edit(todo: Todo)
    case fetch
}
