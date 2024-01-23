//
//  CategoriesListView.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 21.01.2024.
//

import SwiftUI
import ComposableArchitecture

struct CategoriesListView: View {
    let store: Store<CategoriesListDomain.State, CategoriesListDomain.Action>
    @State private var startAnimation = false
    
    var body: some View {
        NavigationStackStore(
            self.store.scope(state: \.path, action: { .path($0) }),
            root: {
                WithViewStore(self.store, observe: { $0 }) { viewStore in
                    NavigationView {
                        ZStack {
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: startAnimation ? .topTrailing : .bottomLeading,
                                endPoint: startAnimation ? .bottomTrailing : .topTrailing
                            )
                            .ignoresSafeArea()
                            .onAppear {
                                withAnimation(.linear(duration: 5.0).repeatForever()) {
                                    startAnimation.toggle()
                                }
                            }
                            
                            VStack {
                                HStack {
                                    Text("Animals")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                
                                ScrollView(.vertical, showsIndicators: false) {
                                    VStack(spacing: 16) {
                                        ForEach(viewStore.categoriesList) { category in
                                            NavigationLink(
                                                state: FactsListDomain.State.init(
                                                    animal: category.animal,
                                                    actualState: category.animal.itemStatus
                                                )
                                            ) {
                                                CategoryCellView(
                                                    animal: category.animal,
                                                    actualState: category.actualState
                                                )
                                            }
                                        }
                                    }
                                    .padding(.top)
                                }
                            }
                        }
                        .task {
                            viewStore.send(.fetchCategories)
                        }
                        .alert(
                            store: self.store.scope(
                                state: \.$confirmationAlert,
                                action: { .alert($0) }
                            )
                        )
                    }
                }
            },
            destination: { store in
                FactsListView(store: store)
            }
        )
    }
}

#Preview {
    CategoriesListView(
        store: Store(
            initialState: CategoriesListDomain.State(),
            reducer: {
                CategoriesListDomain(
                    fetchCategories: { [] }
                )
            }
        )
    )
}
