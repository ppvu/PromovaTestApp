//
//  CategoryDomain.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 21.01.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CategoryDomain {
    struct State: Equatable, Identifiable {
        var id: Animal { animal }
        let animal: Animal
        var actualState: ItemStatus
    }
    
    enum Action: Equatable {
        case setFactsView(ItemStatus)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .setFactsView(let status):
                return .none
            }
        }
    }
}
