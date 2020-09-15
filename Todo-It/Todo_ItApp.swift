import SwiftUI

@main
struct Todo_ItApp: App {
    var body: some Scene {
        WindowGroup {
            TodoListView()
                .environmentObject(
                    AppStore(
                        initialState: .init(PersistenceManager(NotificationCenter.default)),
                         reducer: appReducer
                    )
                )
        }
    }
}
