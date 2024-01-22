//
//  Animal.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 21.01.2024.
//

import Foundation

enum ItemStatus {
    case paid
    case free
    case comingSoon
}

struct Animal: Equatable, Decodable {
    let title: String
    let description: String
    let image: String
    let order: Int
    let status: String
    let content: [Fact]?
    
    var itemStatus: ItemStatus {
        switch status {
        case "paid":
            return .paid
        case "free":
            return .free
        default:
            return .comingSoon
        }
    }
}

extension Animal {
    static var sample: Animal {
        Animal(
            title: "Cats",
            description: "Some description",
            image: "url",
            order: 1,
            status: "paid",
            content: [.init(fact: "123", image: ""), .init(fact: "345", image: ""), .init(fact: "123456", image: "")]
        )
    }
}

struct Fact: Decodable, Equatable, Identifiable {
    let id = UUID()
    let fact: String
    let image: String
}
