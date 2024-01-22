//
//  APIClient.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 21.01.2024.
//

import Foundation
import ComposableArchitecture

struct APIClient {
    var fetchCategories: () async throws -> [Animal]
    
    struct Failure: Error {}
}

extension APIClient {
    static let live = Self(
        fetchCategories: {
            let (data, response) = try await URLSession.shared.data(from: URL(string: "https://raw.githubusercontent.com/AppSci/promova-test-task-iOS/main/animals.json")!)
            let animals = try JSONDecoder().decode([Animal].self, from: data)
            return animals
        }
    )
}
