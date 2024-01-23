//
//  EmptyFactsStateView.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 23.01.2024.
//

import SwiftUI

struct EmptyFactsStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Group {
                Text(":(")
                Text("Ooops... There are no facts about this animal.")
                Text("Please, try again later")
            }
            .font(.system(size: 22, weight: .semibold))
            .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    EmptyFactsStateView()
}
