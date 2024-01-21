//
//  CategoryCellView.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 21.01.2024.
//

import SwiftUI

struct CategoryCellView: View {
    let title: String
    let subtitle: String
    let imageURL: String
    let isPaid: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            AsyncImage(url: URL(string: imageURL)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 121, height: 90)
            .padding(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Title")
                    .font(.system(size: 16, weight: .bold))
                
                Text("Subtitle")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.gray)
                
                if isPaid {
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
            .padding(.top, 12)
            
            Spacer()
        }
        .background(.white)
        .cornerRadius(8)
        .padding(.horizontal, 24)
        .shadow(color: .black.opacity(0.3), radius: 5)
    }
}

#Preview {
    CategoryCellView(title: "Cats", subtitle: "All about cats", imageURL: "", isPaid: true)
}
