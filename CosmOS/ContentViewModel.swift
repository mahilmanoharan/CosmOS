import Foundation
import Combine

class ContentViewModel: ObservableObject {
    // @Published tells the UI: "When this variable changes, redraw the screen!"
    @Published var currentPhoto: APODItem?
    @Published var errorMessage: String?
    
    // Data storage for ForEach
    @Published var favorites: [APODItem] = []
    
    func addToFavorites() {
        if let photo = currentPhoto {
            favorites.append(photo)
        }
    }
    
    // Function to handle date changes
        func loadData(for date: Date = Date()) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd" // NASA's required format
            let dateString = formatter.string(from: date)
            
            APIService.fetchPhoto(date: dateString) { [weak self] result in
                switch result {
                case .success(let photo):
                    self?.currentPhoto = photo
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
}
