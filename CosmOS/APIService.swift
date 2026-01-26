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
    
    // get mars photos
    static func fetchMarsPhoto(date: String?) async throws -> [MarsPhoto] {
        
        let urlString = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?earth_date=\(date)&api_key=DEMO_KEY"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(MarsRoverModel.self, from: data)
        return response.photos
        
    }
}
