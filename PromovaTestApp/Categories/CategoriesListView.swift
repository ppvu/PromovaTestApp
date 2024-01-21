//
//  CategoriesListView.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 21.01.2024.
//

import SwiftUI

struct CategoriesListView: View {
    @State private var startAnimation = false
    
    var body: some View {
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
                        CategoryCellView(title: "Cats", subtitle: "All about", imageURL: "https://upload.wikimedia.org/wikipedia/commons/2/2b/WelshCorgi.jpeg", isPaid: false)
                        CategoryCellView(title: "Dogs", subtitle: "All about DOGS", imageURL: "https://upload.wikimedia.org/wikipedia/commons/2/2b/WelshCorgi.jpeg", isPaid: true)
                        CategoryCellView(title: "Snakes", subtitle: "1234", imageURL: "https://upload.wikimedia.org/wikipedia/commons/2/2b/WelshCorgi.jpeg", isPaid: false)
                    }
                    .padding(.top)
                }
            }
        }
    }
}

#Preview {
    CategoriesListView()
}
