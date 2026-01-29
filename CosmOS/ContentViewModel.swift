import Foundation
import Combine

class ContentViewModel: ObservableObject {
    // @Published tells the UI: "When this variable changes, redraw the screen!"
    @Published var currentPhoto: APODItem?
    @Published var errorMessage: String?
    
    // Data storage for ForEach
    @Published var favorites: [APODItem] = []
    @Published var marsPhoto: [MarsPhoto] = []
    
    // Function to handle date changes
        func loadData(for date: Date = Date()) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateString = formatter.string(from: date)
            
            
            // for APOD photo
            Task {
                do {
                    // We "await" the result
                    let photo = try await APIService.fetchPhoto(date: dateString)
                    self.currentPhoto = photo
                } catch {
                    self.errorMessage = error.localizedDescription
                }
            }
            
            // for mars photo
            Task {
                do {
                    self.marsPhoto = []
                    let photo = try await APIService.fetchMarsPhoto(date: dateString)
                    self.marsPhoto = photo
                } catch{
                    print("Mars photo error: \(error.localizedDescription)")
                }
            }
        }
    
    // Update this specific function
        func addToFavorites(note: String) {
            if var photo = currentPhoto {
                // Attach the note to the photo before saving
                photo.userNote = note
                favorites.append(photo)
            }
        }
    
    // Function to remove a specific item
        func removeFavorite(photo: APODItem) {
            if let index = favorites.firstIndex(where: { $0.id == photo.id }) {
                favorites.remove(at: index)
            }
        }
}
