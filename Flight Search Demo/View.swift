//
//  View.swift
//  Flight Search Demo
//
//  Created by Vishal on 30/09/25.
//

import SwiftUI
struct SearchView: View {
    
    @StateObject var vm = SearchViewModel()
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        Form {
            Section(header: Text("Flight Search").font(.title)) {
                Picker(selection: Binding(get: { vm.origin }, set: { new in
                    vm.origin = new
                    Task { await vm.loadDestinations(for: new) }
                }), label: Text("Origin")) {
                    ForEach(vm.origins) { a in
                        Text(a.name)
                        .tag(Optional(a))
                    }
                }
                .accessibilityLabel(Text("Origin airport, currently set to \(vm.origin?.name ?? "not set")"))
                .frame(minHeight: 44)
                if vm.isLoadingDestinations { ProgressView().frame(height:
                                                                    44) }
                Picker(selection: $vm.destination, label:
                        Text("Destination")) {
                    ForEach(vm.destinations) { a in
                        Text(a.name).tag(Optional(a))
                    }
                }
                        .accessibilityLabel(Text("Destination airport, currently set to \(vm.destination?.name ?? "not set")"))
                        .frame(minHeight: 44)
                DatePicker("Flight date", selection: $vm.date,
                           displayedComponents: .date)
                .accessibilityLabel(Text("Flight date, currently set to \(vm.date, format: .dateTime.month().day().year())"))
                .frame(minHeight: 44)
                Button(action: {
                    guard let origin = vm.origin, let destination = vm.destination else { return }
                    coordinator.showResults(origin: origin, destination:destination, date: vm.date)
                }) {
                    Text("Search flights")
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .contentShape(Rectangle())
                }
                .accessibilityLabel(Text("Search flights"))
            }
            .onAppear {
            }
        }
    }
}


struct FlightRow: View {
    let flight: Flight
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading) {
                Text(flight.flightID).bold().font(.headline)
                HStack {
                    Text(flight.departure.to12HourTime())
                    Text("→")
                    Text(flight.arrival.to12HourTime())
                }
                .font(.subheadline)
            }
            Spacer()
            Text("\(Int(flight.price))")
                .font(.headline)
                .accessibilityLabel("Price \(Int(flight.price)) rupees")
        }
        .padding(.vertical, 8)
    }
}

struct ResultsView: View {
    let args: ResultsArgs
    @StateObject private var vm = ResultsViewModel()
    var body: some View {
        VStack {
            if vm.isLoading {
                ProgressView("Loading flights...")
                    .padding()
            }
            if let error = vm.errorMessage {
                Text(error).foregroundColor(.red).padding()
            }
            if vm.flights.isEmpty && !vm.isLoading {
                Text("No flights available for \(args.origin.code) → \(args.destination.code)")
                    .padding()
            }
            List(vm.flights) { f in
                FlightRow(flight: f)
            }
            .listStyle(.plain)
            .refreshable {
                await vm.search(origin: args.origin.code, destination:
                                    args.destination.code, date: args.date)
            }
        }
        .navigationTitle("Flights: \(args.origin.code)→\(args.destination.code)")
        .task {
            await vm.search(origin: args.origin.code, destination:
                                args.destination.code, date: args.date)
        }
    }
}
