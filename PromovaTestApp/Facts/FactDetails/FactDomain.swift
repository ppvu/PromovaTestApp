//
//  FactDomain.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 21.01.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct FactDomain {
    struct State: Equatable {
        var shouldDisablePreviousButton = true
        var shouldDisableNextButton = false
    }
    
    enum Action: Equatable {
        case moveButtonTapped(MoveButton)
        
        enum MoveButton {
            case previous
            case next
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .moveButtonTapped(let type):
                switch type {
                case .previous:
                    state.shouldDisableNextButton = false
                    return .none
                case .next:
                    state.shouldDisablePreviousButton = false
                    return .none
                }
            }
        }
    }
}
