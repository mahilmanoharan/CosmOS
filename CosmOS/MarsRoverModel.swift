import Foundation

struct MarsRoverModel: Codable {
    let photos: [MarsPhoto]
}

//photo data structure
struct MarsPhoto: Codable, Identifiable{
    let id: Int
    let imgSrc:String
    let earthDate:String
    
    
    //this bit is necessary to convert nasa data in snake to camel
    enum CodingKeys: String, CodingKey {
        case id
        case imgSrc = "img_src"
        case earthDate = "earth_date"
    }
}
