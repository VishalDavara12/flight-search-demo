//
//  SearchView.swift
//  Flight Search Demo
//
//  Created by Vishal on 30/09/25.
//

import SwiftUI


struct SearchView: View {
    
    // MARK: - ViewModel and Coordinator
    // Using @StateObject to manage the lifecycle of the ViewModel within this view
    @StateObject var vm = SearchViewModel()
    
    // Accessing a shared AppCoordinator instance from the environment
    @EnvironmentObject var coordinator: AppCoordinator
    
    // MARK: - Body
    var body: some View {
        Form {
            // MARK: Flight Search Section
            Section(header: Text("Flight Search").font(.appTitle)) {
                
                // MARK: Origin Picker
                // Displays list of available origin airports.
                // When a new origin is selected, it triggers destination loading.
                Picker(selection: Binding(
                    get: { vm.origin },
                    set: { new in
                        vm.origin = new
                        Task { await vm.loadDestinations(for: new) } // Load destinations for selected origin
                    }
                ), label: Text("Origin").font(.appLabel)) {
                    ForEach(vm.origins) { a in
                        Text(a.name)
                            .font(.appLabel)
                            .tag(Optional(a))
                    }
                }
                .accessibilityLabel(Text("Origin airport, currently set to \(vm.origin?.name ?? "not set")"))
                .frame(minHeight: 44)
                .overlay {
                    // Display loader while destinations are being fetched
                    if vm.isLoadingDestinations {
                        ProgressView().frame(height: 44)
                    }
                }
                
                // MARK: Destination Picker
                // Displays list of available destination airports after origin selection.
                Picker(selection: $vm.destination,
                       label: Text("Destination").font(.appLabel)) {
                    ForEach(vm.destinations) { a in
                        Text(a.name)
                            .font(.appLabel)
                            .tag(Optional(a))
                    }
                }
                .accessibilityLabel(Text("Destination airport, currently set to \(vm.destination?.name ?? "not set")"))
                .frame(minHeight: 44)
                
                // MARK: Date Picker
                // Allows user to select a flight date.
                DatePicker("Flight date", selection: $vm.date, displayedComponents: .date)
                    .font(.appLabel)
                    .accessibilityLabel(Text("Flight date, currently set to \(vm.date, format: .dateTime.month().day().year())"))
                    .frame(minHeight: 44)
                
                // MARK: Search Button
                // Triggers the flight search if origin and destination are selected.
                Button(action: {
                    guard let origin = vm.origin, let destination = vm.destination else { return }
                    coordinator.showResults(origin: origin, destination: destination, date: vm.date)
                }) {
                    Text("Search flights")
                        .font(.appButton)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .contentShape(Rectangle())
                }
                .accessibilityLabel(Text("Search flights"))
            }
        }
    }
}
