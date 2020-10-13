import SwiftUI

struct TodoView: View {
    @Binding var todo: Todo
    @State private var isDisplayingDatePicker = true
    var closure: (Todo) -> Void
    
    var body: some View {
        VStack {
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
            .onTapGesture {
                isDisplayingDatePicker.toggle()
            }
            
            if isDisplayingDatePicker {
                DatePicker("Due date", selection: $todo.dueDate, in: Date()..., displayedComponents: .date)
                    .labelsHidden()
            }
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    @State static var todo: Todo = {
        let manager = PersistenceManager()
        let todo = Todo(context: manager.persistentContainer.viewContext)
        
        todo.createdDate = Date()
        todo.dueDate = Date()
        todo.id = UUID()
        todo.isCompleted = false
        todo.title = "Walk the dog"
        
        return todo
    }()
    
    static var previews: some View {
        TodoView(todo: $todo) { _ in }
    }
}
