typealias Reducer<State, Action> = (inout State, Action) -> Void

func appReducer(state: inout AppState, action: AppAction) {
    switch action {
    case let .add(todo):
        state.todos.append(todo)
    case let .delete(offsets):
        state.todos.remove(atOffsets: offsets)
    case let .edit(todo):
        guard let index = state.todos.firstIndex(of: todo) else { return }
        state.todos[index] = todo
    }
}
