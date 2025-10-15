//
//  Utils.swift
//  Flight Search Demo
//
//  Created by Vishal on 30/09/25.
//

import Foundation
import SwiftUI

// MARK: - Date Extension
extension Date {
    
    /// Converts a `Date` instance to an ISO-style string (yyyy-MM-dd).
    /// Uses the shared `isoFormatter` from `MockAPIClient`.
    /// - Returns: ISO formatted string representing the date.
    func toISODateString() -> String {
        MockAPIClient.isoFormatter.string(from: self)
    }
}

// MARK: - String Extension
extension String {
    
    /// Converts a 24-hour time string (HH:mm) to 12-hour format with AM/PM.
    /// - Returns: Converted string in "h:mm a" format, or returns original string if parsing fails.
    func to12HourTime() -> String {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        
        guard let date = df.date(from: self) else { return self }
        
        let out = DateFormatter()
        out.dateFormat = "h:mm a"
        return out.string(from: date)
    }
}

// MARK: - Font Extension
extension Font {
    
    /// App Title font style (large, bold)
    static var appTitle: Font {
        .system(size: 24, weight: .bold, design: .default)
    }
    
    /// Standard label font style
    static var appLabel: Font {
        .system(size: 16, weight: .regular, design: .default)
    }
    
    /// Button font style (semibold, rounded)
    static var appButton: Font {
        .system(size: 18, weight: .semibold, design: .rounded)
    }
    
    /// Subheadline font style (medium weight)
    static var appSubheadline: Font {
        .system(size: 14, weight: .medium, design: .default)
    }
}
