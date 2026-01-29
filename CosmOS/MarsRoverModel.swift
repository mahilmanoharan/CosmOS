import Foundation

struct MarsRoverModel: Codable {
    let photos: [MarsPhoto]
    
    enum CodingKeys: String, CodingKey{
        case photos
        case latestPhotos = "latest_photos"
    }
    
    init (from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let regularList = try? container.decode([MarsPhoto].self, forKey: .photos){
            photos = regularList
        }
        else if let latestList = try? container.decode([MarsPhoto].self, forKey: .latestPhotos){
            photos = latestList
        }
        else{
            photos = []
        }
    }
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
