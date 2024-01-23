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
        var path = StackState<FactsListDomain.State>()
        @PresentationState var confirmationAlert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case fetchCategories
        case fetchCategoriesResponse(TaskResult<[Animal]>)
        case alert(PresentationAction<Alert>)
        case setNavigation(selection: UUID?)
        case setNavigationIsActiveDelayCompleted(selection: UUID)
        case path(StackAction<FactsListDomain.State, FactsListDomain.Action>)
        
        enum Alert: Equatable {
            case didConfirmAlert(FactsListDomain.State)
            case didCancelAlert
        }
    }
    
    @Dependency(\.continuousClock) var clock
    private enum CancelID { case load }
    
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
                            CategoryDomain.State(animal: $0, actualState: $0.itemStatus)
                        }
                )
                return .none
            case .fetchCategoriesResponse(.failure(let error)):
                print("---> \(error)")
                return .none
            case .alert(.presented(.didConfirmAlert(let factsState))):
                return .none
            case .alert(.presented(.didCancelAlert)):
                state.confirmationAlert = nil
                return .none
            case .alert:
                return .none
            case .setNavigation(let selection):
                guard let selection else { return .none }

                return .run { send in
                    try await self.clock.sleep(for: .seconds(2))
                    await send(.setNavigationIsActiveDelayCompleted(selection: selection))
                }
                .cancellable(id: CancelID.load)
            case .setNavigationIsActiveDelayCompleted(let selection):
                return .none
            case .path(.push(id: let id, state: let test)):
                print("---> \(id)")
                print("---> \(test)")
                switch test.animal.itemStatus {
                case .paid:
//                    state.confirmationAlert = AlertState(
//                        title: TextState("Title"),
//                        message: TextState("Do you want to...?"),
//                        buttons: [
//                            .cancel(TextState("Cancel"), action: .send(.didCancelAlert)),
//                            .default(TextState("OK"), action: .send(.didConfirmAlert(test)))
//                        ]
//                    )
                    return .none
                case .free:
                    state.confirmationAlert = nil
                case .comingSoon:
                    return .none
                }
                return .none
            default:
                return .none
            }
        }
        .ifLet(\.$confirmationAlert, action: /CategoriesListDomain.Action.alert)
        .forEach(\.path, action: /CategoriesListDomain.Action.path) {
            FactsListDomain()
        }
    }
}
