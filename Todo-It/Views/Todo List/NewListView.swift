import SwiftUI

struct NewListView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store: AppStore
    @State private var title = ""
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "list.bullet")
                    .foregroundColor(Color.blue.opacity(0.6))
                
                TextField("List title", text: $title)
                    .frame(width: 200)
            }
            .padding(12)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue.opacity(0.6), lineWidth: 0.8)
            )
            
            Button("Save") {
                store.send(.addList(title))
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.white)
            .padding(10)
            .background(Color.blue)
            .cornerRadius(12)
            .padding(8)
        }
    }
}

struct NewListView_Previews: PreviewProvider {
    @State static var title = ""
    static var previews: some View {
        NewListView()
    }
}
