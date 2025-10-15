//
//  FlightRow.swift
//  Flight Search Demo
//
//  Created by Vishal davara on 11/10/2025.
//

import SwiftUI

struct FlightRow: View {
    
    // MARK: - Input Model
    // Represents a single flight's data (ID, times, and price).
    let flight: Flight
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 12) {
            
            // MARK: Flight Details (Left Side)
            VStack(alignment: .leading) {
                
                // MARK: Flight ID
                // Displays the unique flight identifier.
                Text(flight.flightID)
                    .bold()
                    .font(.appLabel)
                
                // MARK: Flight Time Range
                // Shows departure and arrival times in 12-hour format.
                HStack {
                    Text(flight.departure.to12HourTime())
                        .font(.appSubheadline)
                    
                    Text("→")
                        .font(.appSubheadline)
                    
                    Text(flight.arrival.to12HourTime())
                        .font(.appSubheadline)
                }
            }
            
            Spacer()
            
            // MARK: Flight Price (Right Side)
            // Displays flight price in rupees with accessibility support.
            Text("\(flight.currency)\(Int(flight.price))")
                .font(.appLabel)
                .accessibilityLabel("Price \(Int(flight.price)) rupees")
        }
        .padding(.vertical, 8) // Adds vertical spacing for better readability.
    }
}
