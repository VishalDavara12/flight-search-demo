//
//  Flight_Search_DemoApp.swift
//  Flight Search Demo
//
//  Created by Vishal on 30/09/25.
//

import SwiftUI

// MARK: - App Entry Point
/// Main entry point for the FlightSearchDemo SwiftUI app.
/// Sets up navigation stack and injects the AppCoordinator.
@main
struct FlightSearchDemoApp: App {
    
    // MARK: - State Objects
    /// Coordinator responsible for managing navigation flow.
    @StateObject private var coordinator = AppCoordinator()
    
    // MARK: - Scene
    var body: some Scene {
        WindowGroup {
            
            // NavigationStack allows programmatic navigation using NavigationPath
            NavigationStack(path: $coordinator.path) {
                
                // Initial search view
                SearchView()
                    .environmentObject(coordinator) // Inject coordinator for navigation
                
                    // Define destination for ResultsArgs in the navigation path
                    .navigationDestination(for: ResultsArgs.self) { args in
                        ResultsView(args: args)
                    }
            }
        }
    }
}
