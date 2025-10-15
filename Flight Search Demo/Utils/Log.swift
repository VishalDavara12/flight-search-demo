//
//  Log.swift
//  Flight Search Demo
//
//  Created by Vishal davara on 11/10/2025.
//

import Foundation

/// Simple logging utility for SwiftUI apps.
/// Logs appear only in DEBUG mode.
struct Log {
    
    /// Print info logs (default level)
    static func info(_ message: String,
                     file: String = #file,
                     function: String = #function,
                     line: Int = #line) {
        #if DEBUG
        print("ℹ️ [INFO] \(sourceFileName(filePath: file)):\(line) \(function) -> \(message)")
        #endif
    }
    
    /// Print warning logs
    static func warning(_ message: String,
                        file: String = #file,
                        function: String = #function,
                        line: Int = #line) {
        #if DEBUG
        print("⚠️ [WARNING] \(sourceFileName(filePath: file)):\(line) \(function) -> \(message)")
        #endif
    }
    
    /// Print error logs
    static func error(_ message: String,
                      file: String = #file,
                      function: String = #function,
                      line: Int = #line) {
        #if DEBUG
        print("❌ [ERROR] \(sourceFileName(filePath: file)):\(line) \(function) -> \(message)")
        #endif
    }
    
    /// Extract file name from full path
    private static func sourceFileName(filePath: String) -> String {
        return (filePath as NSString).lastPathComponent
    }
}
