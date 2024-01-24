//
//  APIClient.swift
//  PromovaTestApp
//
//  Created by Yevhen Kononenko on 21.01.2024.
//

import Foundation
import ComposableArchitecture

fileprivate enum Constants {
    static let url = "https://raw.githubusercontent.com/AppSci/promova-test-task-iOS/main/animals.json"
}

struct APIClient {
    var fetchCategories: () async throws -> [Animal]
}

extension APIClient {
    static let live = Self(
        fetchCategories: {
            let (data, response) = try await URLSession.shared.data(from: URL(string: Constants.url)!)
            let animals = try JSONDecoder().decode([Animal].self, from: data)
            return animals
        }
    )
}
