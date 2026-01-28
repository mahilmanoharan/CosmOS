import SwiftUI

struct MarsGalleryView: View {
    let photos: [MarsPhoto]
    
    var body: some View{
        VStack(alignment: .leading) {
            Label("Mars Rover: Curiosity", systemImage: "rover")
                .font(.headline)
                .foregroundColor(Color(.orange))
                .padding(.horizontal)
            
            if photos.isEmpty {
                Text("No photo for this date.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            } else{
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 15){
                        ForEach(photos) { photo in
                            AsyncImage(url: URL(string: photo.imgSrc)) {image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                Color.black.opacity(0.3)
                            }
                            .frame(width: 140, height: 140)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12)
                                     
                                .stroke(Color.orange.opacity(0.5), lineWidth: 1))
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.vertical)
    }
}
