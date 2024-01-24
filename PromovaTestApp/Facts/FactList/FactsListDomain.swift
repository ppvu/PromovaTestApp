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
        var factDomain = FactDomain.State()
        var isShareSheetPresented = false
    }
    
    enum Action: Equatable {
        case fact(FactDomain.Action)
        case tabSelected(Int)
        case setSheet(isPresented: Bool)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.factDomain, action: \.fact) {
            FactDomain()
        }
        Reduce { state, action in
            switch action {
            case .fact(let action):
                switch action {
                case .moveButtonTapped(let type):
                    switch type {
                    case .previous:
                        let isButtonDisabled = state.factDomain.selectedIndex == 0
                        state.factDomain.shouldDisablePreviousButton = isButtonDisabled
                        return Effect.send(.tabSelected(state.factDomain.selectedIndex))
                    case .next:
                        guard let facts = state.animal.content else { return .none }
                        let isButtonDisabled = state.factDomain.selectedIndex == facts.count - 1
                        state.factDomain.shouldDisableNextButton = isButtonDisabled
                        return Effect.send(.tabSelected(state.factDomain.selectedIndex))
                    }
                }
            case .tabSelected(let index):
                state.factDomain.selectedIndex = index
                return .none
            case .setSheet(let isPresented):
                state.isShareSheetPresented = isPresented
                return .none
            }
        }
    }
}
