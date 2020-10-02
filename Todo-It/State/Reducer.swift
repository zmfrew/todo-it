typealias Reducer<State, Action> = (inout State, Action) -> Void
// TODO: - Reconsider what actions are necessary as all todos are tied to lists.
func appReducer(state: inout AppState, action: AppAction) {
    switch action {
    case let .addList(list):
        guard !list.title.isEmpty else { return }
        
        state.listStore.add(list)
        state.saveLists()
        
    case let .addTodo(todo):
        state.todoStore.add(todo)
        
        let trimmedTitle = todo.title.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedTitle.isEmpty {
            state.saveTodos()
        }
        
    case let .deleteLists(offsets):
        let lists = state.listStore.delete(atOffsets: offsets)
        state.deleteLists(lists)
        
    case let .deleteTodos(offsets):
        let todos = state.todoStore.delete(atOffsets: offsets)
        state.deleteTodos(todos)
        
    case let .edit(todo):
        state.todoStore.edit(todo)
        state.saveTodos()
    }
}
