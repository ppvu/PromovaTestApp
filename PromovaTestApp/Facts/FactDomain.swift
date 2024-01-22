//
//  FactDomain.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 21.01.2024.
//

import Foundation
import ComposableArchitecture

enum MoveButton {
    case previous
    case next
}

@Reducer
struct FactDomain {
    struct State: Equatable {
        var selectedIndex = 0
        var shouldDisablePreviousButton = true
        var shouldDisableNextButton = false
    }
    
    enum Action: Equatable {
        case moveButtonTapped(MoveButton)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .moveButtonTapped(let type):
                switch type {
                case .previous:
                    state.shouldDisableNextButton = false
                    state.selectedIndex -= 1
                    return .none
                case .next:
                    state.shouldDisablePreviousButton = false
                    state.selectedIndex += 1
                    return .none
                }
            }
        }
    }
}
