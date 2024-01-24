//
//  Animal.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 21.01.2024.
//

import Foundation

struct Animal: Equatable, Decodable, Hashable, Identifiable {
    enum Status: String, Decodable {
        case paid
        case free
    }
    
    let id = UUID()
    let title: String
    let description: String
    let image: String
    let order: Int
    var status: Status
    let content: [Fact]?
    
    enum CodingKeys: String, CodingKey {
        case title, description, image, order, status, content
    }
    
    mutating func setStatus(newStatus: Status) {
        status = newStatus
    }
}

extension Animal {
    static var sample: Animal {
        Animal(
            title: "Cats",
            description: "Some description",
            image: "url",
            order: 1,
            status: .paid,
            content: [.init(fact: "123", image: ""), .init(fact: "345", image: ""), .init(fact: "123456", image: "")]
        )
    }
}
