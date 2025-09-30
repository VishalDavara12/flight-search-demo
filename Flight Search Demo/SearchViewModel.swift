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
    
    @Published var origin: Airport?
    @Published var destination: Airport?
    @Published var date: Date = Date()
    @Published var origins: [Airport] = []
    @Published var destinations: [Airport] = []
    @Published var isLoadingDestinations = false
    @Published var errorMessage: String? = nil
    private let api: APIClientType
    
    init(api: APIClientType = DIContainer.shared.apiClient) {
        self.api = api
        Task { await loadOrigins() }
    }
    
    func loadOrigins() async {
        do {
            let list = try await api.fetchAirports(origin: nil)
            self.origins = list
            if origin == nil { origin = list.first }
            await loadDestinations(for: origin)
        } catch {
            self.errorMessage = "Failed to load airports"
        }
    }
    
    func loadDestinations(for origin: Airport?) async {
        guard let origin = origin else { return }
        isLoadingDestinations = true
        do {
            let result = try await api.fetchAirports(origin: origin.code)
            self.destinations = result
            if let dest = result.first, destination == nil { destination =
                dest }
        } catch {
            self.errorMessage = "Failed to load destinations"
        }
        isLoadingDestinations = false
    }
    func makeSearchCriteriaKey() -> String? {
        guard let origin = origin?.code, let destination = destination?.code
        else { return nil }
        return "\(origin)|\(destination)|\(date.toISODateString())"
    }
}
