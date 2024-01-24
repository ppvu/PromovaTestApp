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
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                ZStack {
                    gradientView()
                    
                    if viewStore.isDataLoading {
                        ProgressView()
                            .frame(width: 100, height: 100)
                    } else if viewStore.shouldShowError {
                        ErrorView(message: "We couldn't fetch animals list unfortunately :(") {
                            viewStore.send(.fetchCategories)
                        }
                    } else {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 16) {
                                ForEach(viewStore.categoriesList) { animal in
                                    CategoryCellView(animal: animal)
                                        .onTapGesture {
                                            viewStore.send(.cellTapped(animal))
                                        }
                                }
                            }
                            .padding(.top)
                            .navigationDestination(
                                store: self.store.scope(
                                    state: \.$path,
                                    action: { .path($0) }
                                )
                            ) { store in
                                FactsListView(store: store)
                            }
                        }
                    }
                }
                .alert(
                    store: self.store.scope(
                        state: \.$confirmationAlert,
                        action: { .alert($0) }
                    )
                )
                .overlay {
                    if viewStore.isLoadingAfterAlertConfirmation {
                        LoadingView(tintColor: .yellow, scaleSize: 2.0)
                    }
                }
                .navigationTitle("Animals")
            }
            .onAppear {
                viewStore.send(.fetchCategories)
            }
        }
    }
    
    private func gradientView() -> some View {
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
