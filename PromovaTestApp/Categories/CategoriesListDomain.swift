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
        var categoriesList: IdentifiedArrayOf<Animal> = []
        var dataLoadingStatus = DataLoadingStatus.notStarted
        var isLoadingAfterAlertConfirmation = false
        
        @PresentationState var path: FactsListDomain.State?
        @PresentationState var confirmationAlert: AlertState<Action.Alert>?
        
        var shouldShowError: Bool {
            dataLoadingStatus == .error
        }
        
        var isDataLoading: Bool {
            dataLoadingStatus == .loading
        }
    }
    
    enum Action {
        case fetchCategories
        case fetchCategoriesResponse(TaskResult<[Animal]>)
        case alert(PresentationAction<Alert>)
        case path(PresentationAction<FactsListDomain.Action>)
        case cellTapped(Animal)
        case isLoadingFinished(Animal)
        
        enum Alert: Equatable {
            case didConfirmAlert(Animal)
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
                return fetchCategories(state: &state)
            case .fetchCategoriesResponse(.success(let animals)):
                state.dataLoadingStatus = .success
                state.categoriesList = IdentifiedArrayOf(uniqueElements: animals.sorted(by: { $0.order < $1.order }))
                return .none
            case .fetchCategoriesResponse(.failure):
                state.dataLoadingStatus = .error
                return .none
            case .alert(.presented(.didConfirmAlert(let animal))):
                return confirmAlertAndLoadView(state: &state, animal: animal)
            case .alert(.presented(.didCancelAlert)):
                state.confirmationAlert = nil
                return .none
            case .alert:
                return .none
            case .cellTapped(let animal):
                guard animal.content != nil else { return .none }
                return selectCell(state: &state, animal: animal)
            case .isLoadingFinished(let animal):
                state.isLoadingAfterAlertConfirmation = false
                return Effect.send(.cellTapped(animal))
            default:
                return .none
            }
        }
        .ifLet(\.$confirmationAlert, action: /CategoriesListDomain.Action.alert)
        .ifLet(\.$path, action: /CategoriesListDomain.Action.path) {
            FactsListDomain()
        }
    }
    
    private func selectCell(
        state: inout State,
        animal: Animal
    ) -> Effect<Action> {
        switch animal.status {
        case .paid:
            state.confirmationAlert = AlertState(
                title: TextState("Watch Ad to continue"),
                buttons: [
                    .cancel(TextState("Cancel"), action: .send(.didCancelAlert)),
                    .default(TextState("Show Ad"), action: .send(.didConfirmAlert(animal)))
                ]
            )
            return .none
        case .free:
            state.confirmationAlert = nil
            state.path = FactsListDomain.State(animal: animal)
            return .none
        }
    }
    
    private func confirmAlertAndLoadView(
        state: inout State,
        animal: Animal
    ) -> Effect<Action> {
        state.isLoadingAfterAlertConfirmation = true
        
        var newAnimal = animal
        newAnimal.setStatus(newStatus: .free)
        
        state.categoriesList[id: newAnimal.id]?.status = .free
        return .run { [newAnimal] send in
            try await self.clock.sleep(for: .seconds(2))
            await send(.isLoadingFinished(newAnimal))
        }
    }
    
    private func fetchCategories(
        state: inout State
    ) -> Effect<Action> {
        if state.dataLoadingStatus == .success || state.dataLoadingStatus == .loading {
            return .none
        }
        
        state.dataLoadingStatus = .loading
        return .run { send in
            await send(.fetchCategoriesResponse(TaskResult { try await fetchCategories() }))
        }
    }
}
