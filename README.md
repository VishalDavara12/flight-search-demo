
# FlightSearchDemo
## Overview
Small SwiftUI app demonstrating a Flight Search flow with filters (origin,
destination, date), results list, short-term caching, and
accessibility support.

## Run
1. Create a SwiftUI iOS project in Xcode (iOS 16+ recommended).
2. Add the sources from the code blocks in `Sources/` (or copy-paste into
separate Swift files).
3. Adjust `MockAPI.baseURL` to your MockAPI endpoint if you want real mock
responses. The app uses a local mock when `MockAPI.baseURL` is empty.

## Time spent
Estimated: 6 hours for the MVVM demo

## Improvements (if more time)
- Add persistence-backed caching (SQLite or CoreData) for offline use.
- Add sorting, passenger selection, and animations.
- Expand unit & UI tests (XCUITest) and add snapshot tests.

## Design decisions
- MVVM keeps views lightweight and testable.
- Coordinator pattern centralizes navigation logic.
