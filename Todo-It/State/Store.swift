import SwiftUI

final class Store<State, Action>: ObservableObject {
    @Published var state: State // TODO: make private(set)
    private let reducer: Reducer<State, Action>
    
    init(initialState: State, reducer: @escaping Reducer<State, Action>) {
        self.state = initialState
        self.reducer = reducer
    }
    
    func send(_ action: Action) {
        reducer(&state, action)
    }
}
