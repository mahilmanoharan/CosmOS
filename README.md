# 🚀 CosmOS: Space Events & Constellation Explorer

### 📖 Project Overview
**CosmOS** is an iOS application designed for astronomy enthusiasts and stargazers. It serves two main purposes: educating users with daily deep-space imagery via the NASA API, and helping users calibrate their stargazing sessions based on their physical location on Earth (Hemisphere data).

The app features a "Time Machine" capability, allowing users to explore space history, and a persistent "Captain's Log" to save favorite discoveries with personal notes.

### 📸 Screenshots
| Mission Control (Home) | Archives (Detail View) |
|:----------------------:|:----------------------:|
| ![Home Screen](<img width="576" height="1027" alt="Screenshot 2025-12-02 at 3 56 41 PM" src="https://github.com/user-attachments/assets/04616a08-8233-4629-a785-9492f593f51e" />) | ![Detail Screen](<img width="565" height="1026" alt="Screenshot 2025-12-02 at 3 56 57 PM" src="https://github.com/user-attachments/assets/151b0930-7e0e-425b-a2a8-dda04382c92d" />) |

### 🛠️ API & Tools Used
* **API:** [NASA Astronomy Picture of the Day (APOD)](https://api.nasa.gov/) - Used to fetch daily high-resolution space imagery, titles, and descriptions.
* **Language:** Swift 6
* **Framework:** SwiftUI
* **Concurrency:** Async/Await (`Task` & `@MainActor`)
* **Architecture:** MVVM (Model-View-ViewModel)

### ✅ Features Implemented
* **Live NASA Data Fetching:** Uses modern `async/await` syntax to retrieve JSON data from NASA's endpoints.
* **Time Travel (Date Picker):** Users can select any past date to retrieve historical APOD data.
* **Hemisphere Calibration:** A dynamic picker that adjusts constellation advice ("Ursa Major" vs. "Southern Cross") based on whether the user is in the Northern or Southern Hemisphere.
* **Favorites & Notes System:** * Users can write custom "Log Entries" using a `TextField`.
    * Data is saved to a local "Archives" list.
    * **Context Menu:** Long-press on any archive item to delete it.
* **Interactive UI:** Uses Glassmorphism (`.ultraThinMaterial`), custom animations, and expandable text descriptions.

### 🚧 Obstacles Faced
1.  **Modern Concurrency (Swift 6):** Adapting the networking layer to use `Task { }` and `async/await` instead of older completion handlers was a challenge. I had to ensure all UI updates were isolated to the `@MainActor` to prevent background thread warnings.
2.  **Data Persistence:** Figuring out how to attach a user's custom note to the API data model (which doesn't have a "note" field) required modifying the local `APODItem` struct to include an optional `userNote` property.

### 🔮 Future Improvements
* **Widget Support:** A home screen widget that displays the "Photo of the Day" without opening the app.
* **CoreData Integration:** Currently, favorites are stored in memory. Future versions will use CoreData or SwiftData to persist favorites even after the app is fully closed.
* **Search Functionality:** Allowing users to search their archives by keywords (e.g., "Nebula", "Galaxy").
