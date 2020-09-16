import SwiftUI

typealias AppStore = Store<AppState, AppAction>

struct TodoListView: View {
    @EnvironmentObject var store: AppStore
    @State private var isAddingTodo = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(store.state.todos.enumerated().map { $0 }, id: \.element.id) { index, todo in
                        TodoView(todo: $store.state.todos[index]) { editedTodo in
                            store.send(.edit(todo: editedTodo))
                        }
                    }
                    .onDelete(perform: delete)
                }
                
                Button(action: {
                    if !isAddingTodo {
                        isAddingTodo = true
                        store.send(.add(todo: Todo(createdDate: Date(),
                                                   id: UUID(),
                                                   isCompleted: false,
                                                   title: "")))
                        isAddingTodo = false
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.all, 40)
                }
            }
            .navigationBarTitle("Todo")
            .onAppear {
                store.send(.fetch)
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        store.send(.delete(at: offsets))
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}
