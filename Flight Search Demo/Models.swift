//
//  Models.swift
//  Flight Search Demo
//
//  Created by Vishal on 30/09/25.
//

import Foundation

struct Flight: Codable, Identifiable, Equatable {
    var id: String { flightID }
    let flightID: String
    let departure: String // HH:mm (24h) from API
    let arrival: String
    let price: Double
}

struct Airports: Codable {
    let airports: [Airport]
}

struct Airport: Codable, Identifiable, Equatable, Hashable {
    let name, code, currency, countryCode: String
    let restrictedOnDeparture, restrictedOnDestination: Bool
    var id: String { code }
}


final class DIContainer {
    static let shared = DIContainer()
    private init() {}
    lazy var apiClient: APIClientType = MockAPIClient()
    lazy var cache = SimpleCache<String, [Flight]>(ttl: 180)
}
