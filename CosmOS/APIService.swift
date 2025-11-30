import Foundation

class APIService {
    
    // accept a dateString in YYYY-MM-DD format
        static func fetchPhoto(date: String?, completion: @escaping (Result<APODItem, Error>) -> Void) {
            
            var urlString = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY"
            
            // If a date is provided, append it to the URL
            if let validDate = date {
                urlString += "&date=\(validDate)"
            }
            
            guard let url = URL(string: urlString) else { return }

            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(APODItem.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
}
