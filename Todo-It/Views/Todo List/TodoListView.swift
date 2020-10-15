import SwiftUI

struct TodoListView: View {
    @EnvironmentObject var store: AppStore
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
            .sheet(isPresented: $isAddingList) {
                NewListView()
                    .environmentObject(store)
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
