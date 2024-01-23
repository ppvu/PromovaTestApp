//
//  FactsListDomain.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 21.01.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct FactsListDomain {
    struct State: Equatable {
        let animal: Animal
        var actualState: ItemStatus
        var factDomain = FactDomain.State()
    }
    
    enum Action: Equatable {
        case backButtonTapped
        case fact(FactDomain.Action)
        case tabSelected(Int)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.factDomain, action: \.fact) {
            FactDomain()
        }
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .none
            case .fact(let action):
                switch action {
                case .moveButtonTapped(let type):
                    switch type {
                    case .previous:
                        if state.factDomain.selectedIndex == 0 {
                            state.factDomain.shouldDisablePreviousButton = true
                        }
                        return Effect.send(.tabSelected(state.factDomain.selectedIndex), animation: .easeInOut)
                    case .next:
                        guard let facts = state.animal.content else { return .none }
                        if state.factDomain.selectedIndex == facts.count - 1 {
                            state.factDomain.shouldDisableNextButton = true
                        }
                        return Effect.send(.tabSelected(state.factDomain.selectedIndex), animation: .easeInOut)
                    }
                }
            case .tabSelected(let index):
                state.factDomain.selectedIndex = index
                return .none
            }
        }
    }
}
