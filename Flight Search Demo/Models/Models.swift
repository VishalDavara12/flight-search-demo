//
//  Models.swift
//  Flight Search Demo
//
//  Created by Vishal on 30/09/25.
//

import Foundation

// MARK: - Flight Model
/// Represents a single flight.
struct Flight: Codable, Identifiable, Equatable {
    
    /// Unique identifier for SwiftUI `Identifiable` conformance
    var id: String { flightID }
    
    let flightID: String       // Flight number / ID
    let departure: String      // Departure time in HH:mm (24h format)
    let arrival: String        // Arrival time in HH:mm (24h format)
    let price: Double          // Ticket price
    let currency: String       // Currency
}

// MARK: - Airports Wrapper
/// Encapsulates an array of `Airport` objects for API decoding.
struct Airports: Codable {
    let airports: [Airport]
}

// MARK: - Airport Model
/// Represents an airport.
struct Airport: Codable, Identifiable, Equatable, Hashable {
    
    let name: String
    let code: String           // Airport code (IATA)
    let currency: String       // Local currency code
    let countryCode: String    // Country code (ISO 3166-1)
    
    let restrictedOnDeparture: Bool  // Whether departures are restricted
    let restrictedOnDestination: Bool // Whether arrivals are restricted
    
    /// Unique identifier for SwiftUI `Identifiable` conformance
    var id: String { code }
}

// MARK: - Dependency Injection Container
/// Provides shared instances of API client and cache.
final class DIContainer {
    
    static let shared = DIContainer()   // Singleton instance
    private init() {}
    
    /// API client for fetching airports and flights
    lazy var apiClient: APIClientType = MockAPIClient()
    
    /// Simple cache for storing flight search results (TTL: 180 seconds)
    lazy var cache = SimpleCache<String, [Flight]>(ttl: 180)
}

