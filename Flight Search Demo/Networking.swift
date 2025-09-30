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
    
    static var baseURL: String = ""
//    static var baseURL: String = "https://api-cert.ezycommerce.sabre.com/api/v1/Airport/OriginsWithConnections/en-us"
    
    func fetchAirports(origin: String? = nil) async throws -> [Airport] {
        try? await Task.sleep(nanoseconds: 200_000_000)
        let list = [
            Airport(code: "DEL", name: "Delhi - Indira Gandhi (DEL)"),
            Airport(code: "BOM", name: "Mumbai - Chhatrapati Shivaji (BOM)"),
            Airport(code: "BLR", name: "Bengaluru (BLR)"),
            Airport(code: "HYD", name: "Hyderabad (HYD)"),
        ]
        if let origin = origin {
            switch origin {
            case "DEL": return list.filter { $0.code != "DEL" }
            case "BOM": return list.filter { $0.code != "BOM" }
            default: return list
            }
        }
        return list
    }
    
    func searchFlights(origin: String, destination: String, date: Date)
    
    async throws -> [Flight] {
        
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        let daySeed = Calendar.current.component(.day, from: date)
        let flights: [Flight] = [
            Flight(flightID: "AI\(100 + (daySeed % 10))"
                   , departure:
                    "09:00", arrival: "11:30", price: Double(10000 + daySeed * 10)),
            Flight(flightID: "6E\(200 + (daySeed % 15))"
                   , departure:
                    "14:00", arrival: "16:30", price: Double(9000 + daySeed * 8)),
            Flight(flightID: "SG\(300 + (daySeed % 7))"
                   , departure: "18:15",
                   arrival: "20:45", price: Double(11000 + daySeed * 12)),
        ]
//        case: if origin == destination, return empty
        if origin == destination { return [] }
        return flights
    }
    
}
