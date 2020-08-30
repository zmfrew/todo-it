import SwiftUI

@main
struct Todo_ItApp: App {
    var body: some Scene {
        WindowGroup {
            TodoListView()
                .environmentObject(
                    AppStore(initialState: .init(), reducer: appReducer)
                )
        }
    }
}
