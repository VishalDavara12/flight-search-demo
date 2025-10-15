//
//  Coordinator.swift
//  Flight Search Demo
//
//  Created by Vishal on 30/09/25.
//

import SwiftUI

// MARK: - App Coordinator
/// Manages navigation flow for the SwiftUI app using a `NavigationPath`.
/// Allows programmatic navigation to results screens with search arguments.
final class AppCoordinator: ObservableObject {
    
    /// Current navigation path (used with `NavigationStack`)
    @Published var path = NavigationPath()
    
    // MARK: - Navigation Actions
    
    /// Navigates to the ResultsView with selected origin, destination, and date.
    /// - Parameters:
    ///   - origin: Selected origin airport
    ///   - destination: Selected destination airport
    ///   - date: Selected flight date
    func showResults(origin: Airport, destination: Airport, date: Date) {
        let args = ResultsArgs(origin: origin, destination: destination, date: date)
        path.append(args)
    }
}

// MARK: - Results Arguments
/// Encapsulates search criteria passed to `ResultsView`.
/// Conforms to `Hashable` to work with SwiftUI `NavigationPath`.
struct ResultsArgs: Hashable {
    let origin: Airport
    let destination: Airport
    let date: Date
}
