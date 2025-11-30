import Foundation

class APIService {
    
    static func fetchPhoto(date: String = "today", completion: @escaping (Result<APODItem, Error>) -> Void) {
        
        // Construct url
        let apiKey = "XuDrvoiyaKDrlK25TeaH0V49qz1jYbSUvE16rU7M"
        
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }

        // Create the URL Session task
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Check for basic network errors
            if let error = error {
                completion(.failure(error))
                return
            }
    
            // Check if we have data
            guard let data = data else { return }
                        
            // FIX: Jump to the Main Thread FIRST, then decode.
            // This satisfies the Swift 6 safety check.
            DispatchQueue.main.async {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(APODItem.self, from: data)
                    completion(.success(result))
                    } catch {
                    completion(.failure(error))
                    }
                }
        }.resume() // Don't forget this! Starts the call.
    }
}
