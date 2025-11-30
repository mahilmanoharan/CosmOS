import Foundation
import Combine

class ContentViewModel: ObservableObject {
    // @Published tells the UI: "When this variable changes, redraw the screen!"
    @Published var currentPhoto: APODItem?
    @Published var errorMessage: String?
    
    // Data storage for ForEach
    @Published var favorites: [APODItem] = []
    
    // Calls service
    func loadData() {
        APIService.fetchPhoto { [weak self] result in
            switch result {
            case .success(let photo):
                self?.currentPhoto = photo
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    func addToFavorites() {
        if let photo = currentPhoto {
            favorites.append(photo)
        }
    }
}
