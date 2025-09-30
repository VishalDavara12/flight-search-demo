//
//  Utils.swift
//  Flight Search Demo
//
//  Created by Vishal on 30/09/25.
//

import Foundation

extension Date {
    func toISODateString() -> String {
        MockAPIClient.isoFormatter.string(from: self)
    }
}

extension String {
    
    func to12HourTime() -> String {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        guard let d = df.date(from: self) else { return self }
        let out = DateFormatter()
        out.dateFormat = "h:mm a"
        return out.string(from: d)
    }
}
