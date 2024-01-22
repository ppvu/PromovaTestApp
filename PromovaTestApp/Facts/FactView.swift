//
//  FactView.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 21.01.2024.
//

import SwiftUI
import ComposableArchitecture

struct FactView: View {
    let store: Store<FactDomain.State, FactDomain.Action>
    let fact: Fact
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 12) {
                AsyncImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/2b/WelshCorgi.jpeg")) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 315, height: 234)
                
                Text(fact.fact)
                    .font(.system(size: 16, weight: .semibold))
                    .multilineTextAlignment(.center)
                
                HStack {
                    Button {
                        viewStore.send(.moveButtonTapped(.previous))
                        /// handle action
                    } label: {
                        Text("previous")
                    }
                    .disabled(viewStore.shouldDisablePreviousButton)
                    /// handle disabled status here due to selectedIndex
                    
                    Spacer()
                    
                    Button {
                        viewStore.send(.moveButtonTapped(.next))
                        /// handle action
                    } label: {
                        Text("next")
                    }
                    .disabled(viewStore.shouldDisableNextButton)
                    /// handle disabled status here due to selectedIndex
                }
                .padding(.horizontal, 22)
            }
            .cornerRadius(8)
        }
    }
}

#Preview {
    FactView(
        store: Store(
            initialState: FactDomain.State(),
            reducer: {
                FactDomain()
            }),
        fact: Fact(fact: "1234", image: "")
    )
}
