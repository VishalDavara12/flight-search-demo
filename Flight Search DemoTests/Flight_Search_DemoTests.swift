//
//  Flight_Search_DemoTests.swift
//  Flight Search DemoTests
//
//  Created by Vishal on 30/09/25.
//

import Testing
import XCTest
@testable import Flight_Search_Demo

final class CacheTests: XCTestCase {
    func testCacheSetGetAndExpiry() {
        let cache = SimpleCache<String, [Flight]>(ttl: 1)
        let key = "A|B|2025-09-30"
        let flights = [Flight(flightID: "T1", departure: "09:00", arrival:
                                "10:00", price: 1000)]
        cache.set(key, value: flights)
        XCTAssertEqual(cache.get(key)?.count, 1)
        
        Thread.sleep(forTimeInterval: 1.2)
        XCTAssertNil(cache.get(key))
    }
}

final class ResultsViewModelTests: XCTestCase {
    func testCachingUsedOnRepeatedSearch() async throws {
        let api = MockAPIClient()
        let cache = SimpleCache<String, [Flight]>(ttl: 60)
        let vm = await ResultsViewModel(api: api, cache: cache)

        await vm.search(origin: "DEL", destination: "BOM", date: Date())
        let first = await MainActor.run { vm.flights }
        XCTAssertFalse(first.isEmpty)

        await vm.search(origin: "DEL", destination: "BOM", date: Date())

        let second = await MainActor.run { vm.flights }
        XCTAssertEqual(second.count, first.count)
    }
}
