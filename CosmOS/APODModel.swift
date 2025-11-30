import Foundation

//JSON Decoding
struct APODItem: Codable, Identifiable {
    var id: UUID = UUID() // swiftUI likes unique IDs for lists
    let date: String
    let title: String
    let explanation: String
    let url: String
    let mediaType: String

    //Map snake case to camel case
    enum CodingKeys: String, CodingKey {
        case date, title, explanation, url
        case mediaType = "media_type"
    }
}
