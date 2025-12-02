import SwiftUI

//This is what shows up when you click on one of your favorited or archived items.
struct DetailView: View {
    let photo: APODItem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Large Image
                AsyncImage(url: URL(string: photo.url)) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Color.black.frame(height: 300)
                }
                .cornerRadius(0) // Edge to edge look
                
                VStack(alignment: .leading, spacing: 15) {
                    Text(photo.title)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text(photo.date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Divider().background(Color.gray)
                    
                    // SHOW THE SAVED NOTE
                    if let note = photo.userNote, !note.isEmpty {
                        VStack(alignment: .leading) {
                            Text("YOUR LOG ENTRY:")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.purple)
                            
                            Text("\"\(note)\"")
                                .font(.title3)
                                .italic()
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                        }
                        .padding(.vertical)
                    }
                    
                    Text("About this object")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(photo.explanation)
                        .font(.body)
                        .foregroundColor(.gray)
                        .lineSpacing(5)
                }
                .padding()
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Deep space background
        .navigationBarTitleDisplayMode(.inline)
    }
}
