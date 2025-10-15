//
//  Networking.swift
//  Flight Search Demo
//
//  Created by Vishal on 30/09/25.
//

import Foundation

// MARK: - Network Error Definition
/// Represents common network and decoding errors for API calls.
enum NetworkError: Error {
    case invalidURL               // URL formation failed
    case invalidResponse          // HTTP response code not 2xx
    case decodingError(Error)     // JSON decoding failed
    case other(Error)             // Any other error
}

// MARK: - API Client Protocol
/// Defines the interface for API clients fetching airports and flight data.
protocol APIClientType {
    /// Fetches airports optionally filtered by origin code.
    func fetchAirports(origin: String?) async throws -> [Airport]
    
    /// Searches flights for a given origin, destination, and date.
    func searchFlights(origin: String, destination: String, date: Date) async throws -> [Flight]
}

// MARK: - Mock API Client
/// A mock implementation of `APIClientType`.
/// Can simulate API responses for testing and development.
final class MockAPIClient: APIClientType {
    
    // MARK: - Constants
    private let session = URLSession.shared
    private let baseAirportURL = "https://api-cert.ezycommerce.sabre.com/api/v1/Airport/OriginsWithConnections/en-us"
    private let tenantHeader = "9d7d6eeb25cd6083e0df323a0fff258e59398a702fac09131275b6b1911e202d"
    
    //TODO: update flight search endpoint to get realtime data
    private let flightSearch = "https://68e9ebeff1eeb3f856e55b13.mockapi.io/fetchFlight"
    
    /// ISO DateFormatter used for date conversions.
    static let isoFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone(secondsFromGMT: 0)
        return f
    }()
    
    // MARK: - Fetch Airports
    /// Fetches airports from the API.
    /// - Parameter origin: Optional origin code to filter airports.
    /// - Returns: An array of `Airport` objects.
    func fetchAirports(origin: String? = nil) async throws -> [Airport] {
        var urlString = baseAirportURL
        if let origin = origin {
            urlString += "?origin=\(origin)"
        }
        
        // Validate URL
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.addValue(tenantHeader, forHTTPHeaderField: "Tenant-Identifier")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            // Validate HTTP status
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            // Decode JSON
            let airports = try JSONDecoder().decode(Airports.self, from: data)
            return airports.airports
        } catch let error as DecodingError {
            Log.error("Decoding error: \(error)")
            throw NetworkError.decodingError(error)
        } catch {
            Log.error("Airport fetch error: \(error)")
            throw NetworkError.other(error)
        }
    }
    
    // MARK: - Search Flights
    /// Simulates flight search API.
    /// Returns mock flight data after a small delay.
    func searchFlights(origin: String, destination: String, date: Date) async throws -> [Flight] {
        guard let url = URL(string: flightSearch) else {
            return []
        }

        // Use async/await version of dataTask
        let (data, _) = try await URLSession.shared.data(from: url)

        // Decode the JSON data
        let flights = try JSONDecoder().decode([Flight].self, from: data)
        return flights
    }
}
