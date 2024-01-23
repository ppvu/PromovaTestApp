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
                AsyncImage(url: URL(string: fact.image)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                
                Spacer()
                
                Text(fact.fact)
                    .font(.system(size: 16, weight: .semibold))
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                HStack {
                    Button {
                        viewStore.send(.moveButtonTapped(.previous))
                    } label: {
                        Image("back_button")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(viewStore.shouldDisablePreviousButton ? .gray : .black)
                            .frame(width: 50, height: 50)
                    }
                    .disabled(viewStore.shouldDisablePreviousButton)
                    
                    Spacer()
                    
                    Button {
                        viewStore.send(.moveButtonTapped(.next))
                    } label: {
                        Image("next_button")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(viewStore.shouldDisableNextButton ? .gray : .black)
                            .frame(width: 50, height: 50)
                    }
                    .disabled(viewStore.shouldDisableNextButton)
                }
            }
            .cornerRadius(8)
            .padding()
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
