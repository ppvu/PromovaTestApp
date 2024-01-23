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
            NavigationView {
                ZStack {
                    Color.green.ignoresSafeArea()
                }
                .overlay(alignment: .center) {
                    if let facts = viewStore.animal.content {
                        TabView(
                            selection: viewStore.binding(
                                get: \.factDomain.selectedIndex,
                                send: FactsListDomain.Action.tabSelected
                            )
                        ) {
                            let fact = facts[viewStore.factDomain.selectedIndex]
                            FactView(
                                store: store.scope(state: \.factDomain, action: \.fact),
                                fact: fact
                            )
                            .tag(fact.id)
                        }
                        .frame(height: 435)
                        .cornerRadius(8)
                        .padding(.horizontal, 24)
                    } else {
                        EmptyFactsStateView()
                    }
                }
            }
            .navigationTitle(viewStore.animal.title)
        }
    }
}

#Preview {
    FactsListView(
        store: Store(
            initialState: FactsListDomain.State(
                animal: Animal.sample,
                actualState: Animal.sample.itemStatus,
                factDomain: FactDomain.State()
            )
        ) {
        FactsListDomain()
    })
}
