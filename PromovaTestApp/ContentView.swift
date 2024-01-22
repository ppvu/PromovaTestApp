//
//  ContentView.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 21.01.2024.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    var body: some View {
        CategoriesListView(
            store: Store(
                initialState: CategoriesListDomain.State()
            ) {
                CategoriesListDomain(
                    fetchCategories: {
                        try await APIClient.live.fetchCategories()
                    }
                )
            }
        )
    }
}

#Preview {
    ContentView()
}
