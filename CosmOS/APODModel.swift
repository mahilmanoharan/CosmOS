import Foundation

//JSON Decoding Requirements

struct APODItem: Codable, Identifiable{
    var id: UUID = UUID()
    let date: String
    let title: String
    let explanation: String
    let url: String
    let mediaType: String
    
    //Map keys to var names(snake to camelcase)
    enum CodingKeys: String, CodingKey{
        case date, title, explanation, url
        case mediaType = "media_type"
    }
}
