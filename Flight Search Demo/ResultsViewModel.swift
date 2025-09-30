//
//  ResultsViewModel.swift
//  Flight Search Demo
//
//  Created by Vishal on 30/09/25.
//

import Foundation

@MainActor
final class ResultsViewModel: ObservableObject {
    
    @Published private(set) var flights: [Flight] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    
    private let api: APIClientType
    private let cache: SimpleCache<String, [Flight]>
    
    init(api: APIClientType = DIContainer.shared.apiClient, cache:
         SimpleCache<String, [Flight]> = DIContainer.shared.cache) {
        self.api = api
        self.cache = cache
    }
    
    
    func search(origin: String, destination: String, date: Date) async {
        let key = "\(origin)|\(destination)|\(date.toISODateString())"
        if let cached = cache.get(key) {
            self.flights = cached
            return
        }
        isLoading = true
        do {
            let res = try await api.searchFlights(origin: origin,
                                                  destination: destination, date: date)
            self.flights = res
            cache.set(key, value: res)
        } catch {
            self.errorMessage = "Search failed"
        }
        isLoading = false
    }
}
