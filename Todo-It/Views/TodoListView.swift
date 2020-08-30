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
                        TodoView(todo: $store.state.todos[index])
                    }
                    .onDelete(perform: delete)
                }
                
                Button(action: {
                    if !isAddingTodo {
                        isAddingTodo = true
                        store.send(.add(todo: Todo(description: "")))
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
        store.send(.delete(at: offsets))
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}
