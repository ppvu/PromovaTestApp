//
//  FactsListView.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 21.01.2024.
//

import SwiftUI
import ComposableArchitecture

struct FactsListView: View {
    enum Alignment {
        case leading
        case trailing
    }
    
    let store: Store<FactsListDomain.State, FactsListDomain.Action>
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                ZStack {
                    Color.green.ignoresSafeArea()
                }
                .overlay(alignment: .center) {
                    if let facts = viewStore.animal.content {
                        TabView(
                            selection: viewStore.binding(
                                get: \.selectedIndex,
                                send: FactsListDomain.Action.tabSelected
                            )
                        ) {
                            let fact = facts[viewStore.selectedIndex]
                            FactView(
                                store: store.scope(state: \.factDomain, action: \.fact),
                                fact: fact
                            )
                            .tag(fact.id)
                        }
                        .frame(height: 500)
                        .cornerRadius(8)
                        .padding(.horizontal, 24)
                    } else {
                        EmptyFactsStateView()
                    }
                }
                .sheet(
                    isPresented: viewStore.binding(
                        get: \.isShareSheetPresented,
                        send: { .setSheet(isPresented: $0) }
                    )
                ) {
                    if let facts = viewStore.animal.content {
                        ActivityView(text: facts[viewStore.selectedIndex].fact)
                    }
                }
            }
            .navigationTitle(viewStore.animal.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: customBarButton(for: .leading) {
                    dismiss()
                },
                trailing: customBarButton(for: .trailing) {
                    viewStore.send(.setSheet(isPresented: true))
                }
            )
        }
    }
    
    private func customBarButton(for alignment: Alignment, onTapGesture: @escaping () -> Void) -> some View {
        let imageName = alignment == .leading ? Images.barButtonName : Images.shareButtonName
        return Image(systemName: imageName)
            .renderingMode(.template)
            .foregroundStyle(.black)
            .onTapGesture {
                onTapGesture()
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
