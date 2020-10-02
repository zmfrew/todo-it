import SwiftUI
// TODO: - Update this view to do
/*
 1. Display list of todolists
 2. Allow adding a new list
 3. Allow deleting lists
 4. Allow renaming lists
 5. Pass todos from the given list into the TodosView
 */
struct TodoListView: View {
    @EnvironmentObject var store: AppStore
    @State private var title = ""
    @State private var isAddingList = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(store.state.listStore.lists) { list in
                        NavigationLink(
                            destination: TodosView().environmentObject(store),
                            label: {
                                Text(list.title)
                            })
                    }
                    .onDelete(perform: delete)
                }
                
                Button(action: {
                    isAddingList = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.all, 40)
                }
            }
            .sheet(isPresented: $isAddingList, onDismiss: {
                store.send(.addList(TodoList(
                                        id: UUID(),
                                        title: title,
                                        todos: []
                                    )
                                )
                            )
            }) {
                NewListView(title: $title)
            }
            .navigationBarTitle("Lists")
        }
    }
    
    func delete(at offsets: IndexSet) {
        store.send(.deleteLists(at: offsets))
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}
