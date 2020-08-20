import SwiftUI

struct TodoListView: View {
    @State private var isAddingTodo = false
    @State private var newTodo = Todo(description: "")
    @State private var todos = [
        Todo(description: "Walk the dog"),
        Todo(description: "Go for a bike ride"),
        Todo(description: "Do the laundry"),
        Todo(description: "Meal prep"),
        Todo(description: "Start Todo app")
    ]
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(todos.enumerated().map { $0 }, id: \.element.id) { index, todo in
                        TodoView(todo: $todos[index])
                    }
                    .onDelete(perform: delete)
                }
                
                Button(action: {
                    if !isAddingTodo {
                        isAddingTodo = true
                        addNewTodo()
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
    
    private func addNewTodo() {
        todos.append(Todo(description: ""))
    }
    
    func delete(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}
