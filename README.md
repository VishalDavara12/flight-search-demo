# FlightSearchDemo

## Overview

A small **SwiftUI** app demonstrating a **Flight Search** flow with filters for **origin**, **destination**, and **date**.
It includes **short-term caching** for API calls, **accessibility support**, and follows the **MVVM architecture pattern** for clean separation of concerns and easy testability.

---

## Architecture

* **Pattern:** Model-View-ViewModel (**MVVM**)

  * **Model:** Defines data structures for flights and airports.
  * **View:** SwiftUI screens for search and results display.
  * **ViewModel:** Handles API requests, caching, and business logic.
* **Coordinator Pattern:** Manages navigation and screen transitions in a centralized, testable way.

---

## Run Instructions (Xcode 16.4)

1. Open the project in **Xcode 16.4** (recommended for best SwiftUI compatibility).
2. Ensure the **deployment target** is iOS 16 or above.
3. Select your **simulator or physical device**.

---

## API Caching

* Implements **short-term in-memory caching** with a configurable **Time-To-Live (TTL)**.
* Prevents redundant network calls for repeated searches within the TTL window.

---

## Project Structure

```
FlightSearchDemo/
│
├── Models/
│   ├── Flight.swift
│   ├── Airport.swift
│
├── ViewModels/
│   ├── SearchViewModel.swift
│   ├── ResultsViewModel.swift
│
├── Views/
│   ├── SearchView.swift
│   ├── ResultsView.swift
│
├── Coordinators/
│   └── AppCoordinator.swift
│
├── Utils/
│   ├── APIClient.swift
│   ├── Cache/
│   │   └── SimpleCache.swift
│   └── Extensions/
│       └── Font.swift   ← Update custom fonts here
│
└── Resources/
    └── Assets.xcassets
```

---

## Font Settings

* Font size and style are customizable via the **Font extension**:

  ```
  Utils → Extensions → Font.swift
  ```

---

## Future Improvements

* **SwiftLint** – Enforce consistent Swift coding style and conventions
  🔗 [SwiftLint GitHub](https://github.com/realm/SwiftLint)
* **SwagGen** – Generate API clients automatically from OpenAPI specs
  🔗 [SwagGen GitHub](https://github.com/SwagGen/SwagGen)
* Add persistent caching (SQLite/Core Data) for offline support.
* Add sorting, passenger selection, and animations.
* Expand **unit tests**, **UI tests (XCUITest)**, and add **snapshot tests**.

---

## Time Spent

Estimated: **6 hours** for the MVVM demo.

---

## Output

🎥 [Demo Video](https://drive.google.com/file/d/1ML-9cOZJBYftG_sxHxpaY6rVyOzUV8cJ/view?usp=sharing)

---

