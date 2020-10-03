import SwiftUI

struct TodoView: View {
    @Binding var todo: Todo
    var closure: (Todo) -> Void
    
    var body: some View {
        HStack {
            Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 30, height: 30)
                .onTapGesture {
                    todo.isCompleted.toggle()
                    closure(todo)
                }
            
            TextField("New todo", text: $todo.title, onCommit: {
                closure(todo)
            })
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    @State static var todo = Todo(
        createdDate: Date(),
        dueDate: Date(),
        id: UUID(),
        isCompleted: false,
        title: "Walk the dog"
    )
    
    static var previews: some View {
        TodoView(todo: $todo) { _ in }
    }
}
