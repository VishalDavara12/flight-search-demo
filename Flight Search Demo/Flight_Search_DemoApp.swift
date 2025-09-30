//
//  Flight_Search_DemoApp.swift
//  Flight Search Demo
//
//  Created by Vishal on 30/09/25.
//

import SwiftUI

@main
struct FlightSearchDemoApp: App {
    @StateObject private var coordinator = AppCoordinator()
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                SearchView()
                    .environmentObject(coordinator)
                    .navigationDestination(for: ResultsArgs.self) { args in
                        ResultsView(args: args)
                    }
            }
        }
    }
}
