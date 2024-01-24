//
//  CategoryCellView.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 21.01.2024.
//

import SwiftUI
import ComposableArchitecture

struct CategoryCellView: View {
    let animal: Animal
    
    var isDisabled: Bool {
        animal.content == nil
    }
    
    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                AsyncImage(url: URL(string: animal.image)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 121, height: 90)
                .clipShape(Circle())
                .padding(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(animal.title)
                        .font(.system(size: 16, weight: .bold))
                    
                    Text(animal.description)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                    
                    if animal.status == .paid {
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
                        .padding(.top)
                    }
                }
                .padding(.vertical)
                
                Spacer()
            }
            .background(.white)
            .cornerRadius(8)
            .padding(.horizontal, 24)
            .shadow(color: .black.opacity(0.3), radius: 5)
        }
        .overlay {
            if isDisabled {
                ZStack {
                    Color.black.opacity(0.6)
                    HStack {
                        Spacer()
                        Image("coming_soon")
                    }
                }
                .cornerRadius(8)
                .padding(.horizontal, 24)
            }
        }
    }
}

#Preview {
    CategoryCellView(animal: .sample)
}
