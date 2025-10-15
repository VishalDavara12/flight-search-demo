//
//  SearchViewModel.swift
//  Flight Search Demo
//
//  Created by Vishal on 30/09/25.
//

import Foundation
import SwiftUI

@MainActor
final class SearchViewModel: ObservableObject {
    
    // MARK: - Published Properties (State)
    // These properties are observed by SwiftUI views to update the UI automatically.
    
    @Published var origin: Airport?                    // Selected origin airport
    @Published var destination: Airport?               // Selected destination airport
    @Published var date: Date = Date()                 // Selected flight date
    @Published var origins: [Airport] = []             // List of available origin airports
    @Published var destinations: [Airport] = []        // List of available destination airports
    @Published var isLoadingDestinations = false       // Indicates if destination data is currently loading
    @Published var errorMessage: String? = nil         // Stores user-friendly error messages
    
    // MARK: - Dependencies
    // API client injected via dependency container (useful for testing & modularity)
    private let api: APIClientType
    
    // MARK: - Initialization
    // Loads origin airports immediately when the view model is created.
    init(api: APIClientType = DIContainer.shared.apiClient) {
        self.api = api
        Task { await loadOrigins() }
    }
    
    // MARK: - Load Origins
    /// Fetches the list of all origin airports from the API.
    /// - If successful: updates `origins` and selects the first one by default.
    /// - Automatically triggers destination loading for the selected origin.
    func loadOrigins() async {
        do {
            let list = try await api.fetchAirports(origin: nil)
            self.origins = list
            if origin == nil {
                origin = list.first // Default to first available origin
            }
            await loadDestinations(for: origin)
        } catch {
            self.errorMessage = "Failed to load airports"
        }
    }
    
    // MARK: - Load Destinations
    /// Fetches destinations available for a given origin airport.
    /// - Parameter origin: The selected origin airport.
    /// - Shows a loading state while the API call is in progress.
    func loadDestinations(for origin: Airport?) async {
        guard let origin = origin else { return }
        isLoadingDestinations = true
        do {
            let result = try await api.fetchAirports(origin: origin.code)
            self.destinations = result
            if let first = result.first, destination == nil {
                destination = first // Default to first available destination
            }
        } catch {
            self.errorMessage = "Failed to load destinations"
        }
        isLoadingDestinations = false
    }
    
    // MARK: - Create Search Key
    /// Creates a unique key combining origin, destination, and date.
    /// Useful for caching or tracking recent searches.
    /// - Returns: A formatted string key like `"DEL|BOM|2025-10-11"`, or `nil` if data is incomplete.
    func makeSearchCriteriaKey() -> String? {
        guard let origin = origin?.code,
              let destination = destination?.code else { return nil }
        return "\(origin)|\(destination)|\(date.toISODateString())"
    }
}
