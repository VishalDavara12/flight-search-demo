//
//  Networking.swift
//  Flight Search Demo
//
//  Created by Vishal on 30/09/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case other(Error)
}

protocol APIClientType {
    func fetchAirports(origin: String?) async throws -> [Airport]
    func searchFlights(origin: String, destination: String, date: Date)
    async throws -> [Flight]
}

final class MockAPIClient: APIClientType {
    static let isoFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone(secondsFromGMT: 0)
        return f
    }()
    
    private let session = URLSession.shared
    private let baseAirportURL = "https://api-cert.ezycommerce.sabre.com/api/v1/Airport/OriginsWithConnections/en-us"
    private let tenantHeader = "9d7d6eeb25cd6083e0df323a0fff258e59398a702fac09131275b6b1911e202d"

    func fetchAirports(origin: String? = nil) async throws -> [Airport] {
        var urlString = baseAirportURL
        if let origin = origin {
            urlString += "?origin=\(origin)"
        }

        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.addValue(tenantHeader, forHTTPHeaderField: "Tenant-Identifier")

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }

            let airports = try JSONDecoder().decode(Airports.self, from: data)
            return airports.airports
        } catch let error as DecodingError {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError(error)
        } catch {
            print("Airport fetch error: \(error)")
            throw NetworkError.other(error)
        }
    }

    func searchFlights(origin: String, destination: String, date: Date) async throws -> [Flight] {
        try? await Task.sleep(nanoseconds: 300_000_000)
        let daySeed = Calendar.current.component(.day, from: date)
        return [
            Flight(flightID: "AI\(100 + daySeed % 10)", departure: "09:00", arrival: "11:30", price: 12000),
            Flight(flightID: "6E\(200 + daySeed % 15)", departure: "14:00", arrival: "16:30", price: 9500)
        ]
    }
}
