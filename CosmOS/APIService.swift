import Foundation

class APIService {
    
    // use the nasa api!!!!!
    static func fetchPhoto(date: String?) async throws -> APODItem {
        
        var urlString = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY"
        
        if let validDate = date {
            urlString += "&date=\(validDate)"
        }
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        return try decoder.decode(APODItem.self, from: data)
    }
}
