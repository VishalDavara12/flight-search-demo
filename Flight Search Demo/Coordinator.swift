//
//  Coordinator.swift
//  Flight Search Demo
//
//  Created by Vishal on 30/09/25.
//

import SwiftUI
final class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    func showResults(origin: Airport, destination: Airport, date: Date) {
        let args = ResultsArgs(origin: origin, destination: destination,
                               date: date)
        path.append(args)
    }
}

struct ResultsArgs: Hashable {
    let origin: Airport
    let destination: Airport
    let date: Date
}
