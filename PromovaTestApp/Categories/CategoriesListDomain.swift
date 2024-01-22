//
//  CategoriesListDomain.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 21.01.2024.
//

import Foundation
import ComposableArchitecture

struct CategoriesListDomain: Reducer {
    struct State: Equatable {
        var categoriesList: IdentifiedArrayOf<CategoryDomain.State> = []
        @PresentationState var confirmationAlert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case fetchCategories
        case fetchCategoriesResponse(TaskResult<[Animal]>)
        case category(id: CategoryDomain.State.ID, action: CategoryDomain.Action)
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {
            case didConfirmAlert(id: CategoryDomain.State.ID)
            case didCancelAlert
        }
    }
    
    var fetchCategories: @Sendable () async throws -> [Animal]
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchCategories:
                return .run { send in
                    await send(.fetchCategoriesResponse(TaskResult { try await fetchCategories() }))
                }
            case .fetchCategoriesResponse(.success(let animals)):
                state.categoriesList = IdentifiedArrayOf(
                    uniqueElements: animals
                        .sorted(by: { $0.order < $1.order })
                        .map {
                            CategoryDomain.State(id: UUID(), animal: $0, actualState: $0.itemStatus)
                        }
                )
                return .none
            case .fetchCategoriesResponse(.failure(let error)):
                print("---> \(error)")
                return .none
            case .category(let id, let action):
                switch action {
                case .setFactsView(let status):
                    switch status {
                    case .paid:
                        state.confirmationAlert = AlertState(
                            title: TextState("Title"),
                            message: TextState("Do you want to...?"),
                            buttons: [
                                .cancel(TextState("Cancel"), action: .send(.didCancelAlert)),
                                .default(TextState("OK"), action: .send(.didConfirmAlert(id: id)))
                            ]
                        )
                        return .none
                    default:
                        state.confirmationAlert = nil
                        return .none
                    }
                }
            case .alert(.presented(.didConfirmAlert(let id))):
                state.categoriesList[id: id]?.actualState = .free
                return .none
            case .alert(.presented(.didCancelAlert)):
                state.confirmationAlert = nil
                return .none
            case .alert:
                return .none
            }
        }
        .forEach(\.categoriesList, action: /CategoriesListDomain.Action.category(id:action:)) {
            CategoryDomain()
        }
        .ifLet(\.$confirmationAlert, action: /CategoriesListDomain.Action.alert)
    }
}
