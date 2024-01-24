//
//  ErrorView.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 24.01.2024.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text(":(")
                .font(.system(size: 32, weight: .semibold))
            
            Text("")
            Text(message)
                .font(.system(size: 16, weight: .semibold))
            Button {
                retryAction()
            } label: {
                Text("Retry")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(width: 100, height: 60)
            .background(.blue)
            .cornerRadius(10)
            .padding()
            
        }
    }
}

#Preview {
    ErrorView(message: "Something went wrong", retryAction: {})
}
