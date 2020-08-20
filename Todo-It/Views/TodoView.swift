import SwiftUI

struct TodoView: View {
    @Binding var todo: Todo
    
    var body: some View {
        HStack {
            Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 30, height: 30)
            
            TextField("Add todo", text: $todo.description) {  }
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    @State static var todo = Todo(description: "Walk the dog")
    static var previews: some View {
        TodoView(todo: $todo)
    }
}
