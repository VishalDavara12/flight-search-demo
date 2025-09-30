//
//  Cache.swift
//  Flight Search Demo
//
//  Created by Vishal on 30/09/25.
//

import Foundation

final class SimpleCache<Key: Hashable, Value> {
    
    private struct Entry {
        let value: Value
        let expiry: Date
    }
    
    private var storage: [Key: Entry] = [:]
    private let lock = NSLock()
    private let ttl: TimeInterval
    
    init(ttl: TimeInterval = 180) {
        self.ttl = ttl
    }
    func get(_ key: Key) -> Value? {
        lock.lock(); defer { lock.unlock() }
        guard let entry = storage[key] else { return nil }
        if entry.expiry > Date() {
            return entry.value
        } else {
            storage.removeValue(forKey: key)
            return nil
        }
    }
    func set(_ key: Key, value: Value) {
        lock.lock(); defer { lock.unlock() }
        let entry = Entry(value: value, expiry:
                            Date().addingTimeInterval(ttl))
        storage[key] = entry
    }
    
    func clear() {
        lock.lock(); defer { lock.unlock() }
        storage.removeAll()
    }
    
}
