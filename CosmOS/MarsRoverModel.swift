import Foundation

struct MarsRoverModel: Decodable {
    let photos: [MarsPhoto]
    
    enum CodingKeys: String, CodingKey{
        case photos
        case latestPhotos = "latest_photos"
    }
    
    init (from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        //debugging...
        print("json data: \(container.allKeys.map { $0.stringValue})")
        
        do{
            let regularList = try container.decode([MarsPhoto].self, forKey: .photos)
                photos = regularList
                print("list of photos with \(regularList.count) items")
                return
        } catch{ print("photo decoding error. try latest photos instead.")}
        do{
            let latestList = try container.decode([MarsPhoto].self, forKey: .latestPhotos)
            photos = latestList
            print("list of photos with \(latestList.count) items")
            return
        } catch{ print("latest photo decode error.")}
        print("both the photo decodes failed...")
        photos = []
    }
}

//photo data structure
struct MarsPhoto: Codable, Identifiable{
    let id: Int
    let imgSrc:String
    let earthDate:String
    
    
    var secureURL: URL?{
        let secureString = imgSrc.replacingOccurrences(of: "http://", with: "https://")
        return URL(string: secureString)
    }
    
    //this bit is necessary to convert nasa data in snake to camel
    enum CodingKeys: String, CodingKey {
        case id
        case imgSrc = "img_src"
        case earthDate = "earth_date"
    }
}
