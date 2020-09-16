typealias Reducer<State, Action> = (inout State, Action) -> Void

func appReducer(state: inout AppState, action: AppAction) {
    switch action {
    case let .add(todo):
        guard !state.todos.contains(todo) else { return }
        
        state.todos.append(todo)
        let trimmedTitle = todo.title.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedTitle.isEmpty {
            state.save()
        }
    case let .delete(offsets):
        state.todos.remove(atOffsets: offsets)

    case let .edit(todo):
        guard let index = state.todos.firstIndex(of: todo) else { return }
        state.todos[index] = todo
        state.save()
        
    case .fetch:
        state.fetch()
    }
}
