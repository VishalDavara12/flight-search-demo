//
//  ResultsViewModel.swift
//  Flight Search Demo
//
//  Created by Vishal on 30/09/25.
//

import Foundation

@MainActor
final class ResultsViewModel: ObservableObject {
    
    // MARK: - Published Properties (Observed by UI)
    // These properties automatically update SwiftUI views when modified.
    
    @Published private(set) var flights: [Flight] = []   // List of fetched flight results (read-only from outside)
    @Published var isLoading: Bool = false               // Tracks whether search API call is in progress
    @Published var errorMessage: String? = nil           // Stores error messages for display in the UI
    
    
    // MARK: - Dependencies
    // Injected services: API client and cache manager for data fetching and reuse.
    
    private let api: APIClientType
    private let cache: SimpleCache<String, [Flight]>
    
    
    // MARK: - Initialization
    /// Initializes the view model with dependencies (DI-friendly).
    /// Defaults to shared instances for API and cache.
    init(
        api: APIClientType = DIContainer.shared.apiClient,
        cache: SimpleCache<String, [Flight]> = DIContainer.shared.cache
    ) {
        self.api = api
        self.cache = cache
    }
    
    
    // MARK: - Search Flights
    /// Searches for available flights using origin, destination, and date.
    /// 1. Checks cache first for previously loaded results.
    /// 2. If not cached, fetches from API and stores in cache.
    /// 3. Handles loading and error states appropriately.
    ///
    /// - Parameters:
    ///   - origin: The origin airport code (e.g., "DEL")
    ///   - destination: The destination airport code (e.g., "BOM")
    ///   - date: The flight date
    func search(origin: String, destination: String, date: Date) async {
        let key = "\(origin)|\(destination)|\(date.toISODateString())" // Unique cache key
        
        // MARK: Cache Check
        // If data already exists in cache, use it directly.
        if let cached = cache.get(key) {
            self.flights = cached
            return
        }
        
        // MARK: API Fetch
        isLoading = true
        do {
            // Call the API to fetch flight results.
            let res = try await api.searchFlights(
                origin: origin,
                destination: destination,
                date: date
            )
            self.flights = res
            
            // Save fetched results to cache for reuse.
            cache.set(key, value: res)
        } catch {
            // MARK: Error Handling
            self.errorMessage = "Search failed"
        }
        isLoading = false
    }
}
