//
//  LoadingView.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 24.01.2024.
//

import SwiftUI

struct LoadingView: View {
    var tintColor: Color = .blue
    var scaleSize: CGFloat = 1
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            ProgressView()
                .scaleEffect(scaleSize, anchor: .center)
                .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
        }
    }
}

#Preview {
    LoadingView()
}
