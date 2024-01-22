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
                                ForEachStore(
                                    self.store.scope(
                                        state: \.categoriesList,
                                        action: CategoriesListDomain.Action.category(id:action:)
                                    )
                                ) { store in
                                    CategoryCellView(store: store)
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
