//
//  Fact.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 24.01.2024.
//

import Foundation

struct Fact: Decodable, Identifiable, Hashable {
    let id = UUID()
    let fact: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case fact, image
    }
}
