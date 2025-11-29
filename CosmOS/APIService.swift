import Foundation

class APIService {

    static func fetchPhoto(date: String = "today", completion: @escaping (Result<APODItem, Error>) -> Void) {
        
        // Construct url
        let apiKey = "demo_key"
        // If getting a specific date, we append &date=YYYY-MM-DD, otherwise it defaults to today
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }

        // URL Session task
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Check for basic network errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check if we have data
            guard let data = data else { return }
            
            // JSON Decoding
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(APODItem.self, from: data)
                
                // Jump back to the main thread to update UI
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume() // Don't forget this! Starts the call.
    }
}
