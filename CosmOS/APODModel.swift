import Foundation

//APOD stands for "astronomy picture of the day!"
struct APODItem: Codable, Identifiable {
    var id: UUID = UUID()
    let date: String
    let title: String
    let explanation: String
    let url: String
    let mediaType: String
    

    // Storing a Note
    var userNote: String? = nil

    enum CodingKeys: String, CodingKey {
        case date, title, explanation, url
        case mediaType = "media_type"
    }
}
