//
//  ResultsView.swift
//  Flight Search Demo
//
//  Created by Vishal davara on 11/10/2025.
//

import SwiftUI

struct ResultsView: View {
    
    // MARK: - Input Arguments
    // Passed-in data from the previous screen, includes origin, destination, and selected date.
    let args: ResultsArgs
    
    // MARK: - ViewModel
    // Manages flight data, loading state, and errors for this view.
    @StateObject private var vm = ResultsViewModel()
    
    // MARK: - Body
    var body: some View {
        VStack {
            
            // MARK: Loading Indicator
            // Shown while fetching flight results from API.
            if vm.isLoading {
                ProgressView("Loading flights...")
                    .font(.appLabel)
                    .padding()
            }
            
            // MARK: Error Message
            // Displayed when an API or network error occurs.
            if let error = vm.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.appLabel)
                    .padding()
            }
            
            // MARK: No Results View
            // Displayed when no flights are available for the selected route.
            if vm.flights.isEmpty && !vm.isLoading {
                Text("No flights available for \(args.origin.code) → \(args.destination.code)")
                    .font(.appLabel)
                    .padding()
            }
            
            // MARK: Flight List
            // Displays list of fetched flight results.
            List(vm.flights) { f in
                FlightRow(flight: f)
            }
            .listStyle(.plain)
            .refreshable {
                // Pull-to-refresh re-fetches flight data.
                await vm.search(
                    origin: args.origin.code,
                    destination: args.destination.code,
                    date: args.date
                )
            }
        }
        // MARK: Navigation & Initial Load
        // Sets navigation title and triggers initial data fetch when the view appears.
        .navigationTitle("Flights: \(args.origin.code)→\(args.destination.code)")
        .font(.appTitle)
        .task {
            // Automatically perform search when view loads.
            await vm.search(
                origin: args.origin.code,
                destination: args.destination.code,
                date: args.date
            )
        }
    }
}
