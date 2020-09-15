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
                }
            
            TextField("New todo", text: $todo.title) {
                closure(todo)
            }
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    @State static var todo = Todo(title: "Walk the dog")
    static var previews: some View {
        TodoView(todo: $todo) { _ in }
    }
}
