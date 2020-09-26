import SwiftUI

struct TodosView: View {
    @EnvironmentObject var store: AppStore
    @State private var isAddingTodo = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(store.state.todoStore.todos.enumerated().map { $0 }, id: \.element.id) { index, todo in
                        TodoView(todo: $store.state.todoStore.todos[index]) { editedTodo in
                            store.send(.edit(todo: editedTodo))
                        }
                    }
                    .onDelete(perform: delete)
                }
                
                Button(action: {
                    if !isAddingTodo {
                        isAddingTodo = true
                        store.send(.addTodo(Todo(
                                                createdDate: Date(),
                                                id: UUID(),
                                                isCompleted: false,
                                                title: ""
                                            )
                                        )
                                    )
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
        }
    }
    
    func delete(at offsets: IndexSet) {
        store.send(.deleteTodos(at: offsets))
    }
}

struct TodosView_Previews: PreviewProvider {
    static var previews: some View {
        TodosView()
    }
}
