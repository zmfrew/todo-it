typealias Reducer<State, Action> = (inout State, Action) -> Void
// TODO: - Reconsider what actions are necessary as all todos are tied to lists.
func appReducer(state: inout AppState, action: AppAction) {
    switch action {
    case let .addList(title):
        guard !title.isEmpty else { return }
        
        state.addList(title)
        
    case let .addTodo(dueDate, title):
        print(dueDate, title)
//        state.add(todo)
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedTitle.isEmpty {
//            state.saveTodos()
        }
        
    case let .deleteLists(offsets):
        print(offsets)
//        let lists = state.delete(atOffsets: offsets)
//        state.deleteLists(lists)
        
    case let .deleteTodos(offsets):
//        let todos = state.todoStore.delete(atOffsets: offsets)
        print(offsets)
//        state.deleteTodos(todos)
        
    case let .edit(todo):
        print(todo)
//        state.todoStore.edit(todo)
//        state.saveTodos()
    }
}
