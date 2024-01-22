//
//  FactsListView.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 21.01.2024.
//

import SwiftUI
import ComposableArchitecture

struct FactsListView: View {
    let store: Store<FactsListDomain.State, FactsListDomain.Action>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Color.green.ignoresSafeArea()
                TabView(
                    selection: viewStore.binding(
                        get: \.factDomain.selectedIndex,
                        send: FactsListDomain.Action.tabSelected
                    )
                ) {
                    if let facts = viewStore.animal.content {
                        let fact = facts[viewStore.factDomain.selectedIndex]
                        FactView(
                            store: store.scope(state: \.factDomain, action: \.fact),
                            fact: fact
                        )
                        .tag(fact.id)
                    }
                }
                .frame(height: 435)
                .cornerRadius(8)
                .padding(.horizontal, 24)
            }
        }
    }
}

#Preview {
    FactsListView(
        store: Store(
            initialState: FactsListDomain.State(
                animal: Animal.sample,
                factDomain: FactDomain.State()
            )
        ) {
        FactsListDomain()
    })
}
