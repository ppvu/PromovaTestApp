//
//  CategoryCellView.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 21.01.2024.
//

import SwiftUI
import ComposableArchitecture

struct CategoryCellView: View {
    let store: Store<CategoryDomain.State, CategoryDomain.Action>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                HStack(alignment: .top, spacing: 16) {
                    AsyncImage(url: URL(string: viewStore.animal.image)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 121, height: 90)
                    .padding(8)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewStore.animal.title)
                            .font(.system(size: 16, weight: .bold))
                        
                        Text(viewStore.animal.description)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        if viewStore.actualState == .paid {
                            HStack(spacing: 4) {
                                Image("lock_icon")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 10, height: 12)
                                    .foregroundColor(.blue)
                                Text("Premium")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding(.vertical)
                    
                    Spacer()
                }
            }
            .background(.white)
            .cornerRadius(8)
            .padding(.horizontal, 24)
            .shadow(color: .black.opacity(0.3), radius: 5)
            .onTapGesture {
                viewStore.send(.setFactsView(viewStore.actualState))
            }
        }
    }
}

#Preview {
    CategoryCellView(
        store: Store(
            initialState: CategoryDomain.State(id: UUID(), animal: .sample, actualState: Animal.sample.itemStatus),
            reducer: {
                CategoryDomain()
            }
        )
    )
}
