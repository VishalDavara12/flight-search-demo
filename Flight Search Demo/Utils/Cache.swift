//
//  Cache.swift
//  Flight Search Demo
//
//  Created by Vishal on 30/09/25.
//

import Foundation

/// A simple thread-safe in-memory cache with TTL (time-to-live) support.
final class SimpleCache<Key: Hashable, Value> {
    
    // MARK: - Cache Entry
    /// Stores the cached value along with its expiration date.
    private struct Entry {
        let value: Value      // Cached value
        let expiry: Date      // Expiration timestamp
    }
    
    // MARK: - Properties
    private var storage: [Key: Entry] = [:]   // Internal dictionary storing cached entries
    private let lock = NSLock()               // Ensures thread-safety for concurrent access
    private let ttl: TimeInterval             // Default time-to-live for each entry (in seconds)
    
    // MARK: - Initialization
    /// Initializes the cache with an optional TTL (default: 180 seconds).
    /// - Parameter ttl: Time-to-live in seconds for cached items.
    init(ttl: TimeInterval = 180) {
        self.ttl = ttl
    }
    
    // MARK: - Public Methods
    
    /// Retrieves a cached value for a given key if it exists and has not expired.
    /// - Parameter key: The key to look up.
    /// - Returns: The cached value, or `nil` if not present or expired.
    func get(_ key: Key) -> Value? {
        lock.lock(); defer { lock.unlock() }   // Ensure thread-safety
        
        guard let entry = storage[key] else { return nil }
        
        if entry.expiry > Date() {
            return entry.value                 // Return valid cached value
        } else {
            storage.removeValue(forKey: key)  // Remove expired entry
            return nil
        }
    }
    
    /// Stores a value in the cache with the configured TTL.
    /// - Parameters:
    ///   - key: The key for the cache entry.
    ///   - value: The value to cache.
    func set(_ key: Key, value: Value) {
        lock.lock(); defer { lock.unlock() }   // Ensure thread-safety
        let entry = Entry(value: value, expiry: Date().addingTimeInterval(ttl))
        storage[key] = entry
    }
    
    /// Clears all entries from the cache.
    func clear() {
        lock.lock(); defer { lock.unlock() }   // Ensure thread-safety
        storage.removeAll()
    }
}
