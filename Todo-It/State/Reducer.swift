typealias Reducer<State, Action> = (inout State, Action) -> Void

func appReducer(state: inout AppState, action: AppAction) {
    switch action {
    case let .add(todo):
        state.todoStore.add(todo)
        
        let trimmedTitle = todo.title.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedTitle.isEmpty {
            state.save()
        }
        
    case let .delete(offsets):
        state.todoStore.delete(atOffsets: offsets)
        
    case let .edit(todo):
        state.todoStore.edit(todo)
        state.save()
    }
}
