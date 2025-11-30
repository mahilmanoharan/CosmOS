import SwiftUI

import SwiftUI

struct ContentView: View {
    // Connects to our logic class
    @StateObject private var viewModel = ContentViewModel()
    
    // REQUIREMENTS: @State properties for inputs
    @State private var userNote: String = ""
    @State private var selectedHemisphere: String = "Northern"
    @State private var showFavorites: Bool = false
    
    let hemispheres = ["Northern", "Southern"]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // HEADER
                    Text("CosmOS Explorer")
                        .font(.largeTitle)
                        .bold()
                    
                    // REQUIREMENT: Picker (Input 1)
                    Picker("Select Hemisphere", selection: $selectedHemisphere) {
                        ForEach(hemispheres, id: \.self) { hemisphere in
                            Text(hemisphere)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    // DYNAMIC CONSTELLATION TEXT
                    // Simple logic to show we used the input
                    Text(selectedHemisphere == "Northern" ? "Look for: Ursa Major tonight!" : "Look for: The Southern Cross tonight!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    // NETWORK IMAGE
                    if let photo = viewModel.currentPhoto {
                        // Using AsyncImage to load URL
                        AsyncImage(url: URL(string: photo.url)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(15)
                        } placeholder: {
                            ProgressView() // Loading spinner
                        }
                        .frame(height: 300)
                        .padding()
                        
                        // DESCRIPTION
                        Text(photo.title)
                            .font(.title2)
                            .bold()
                        
                        Text(photo.explanation)
                            .font(.body)
                            .padding()
                        
                        // REQUIREMENT: TextField (Input 2)
                        TextField("Add a note about this photo...", text: $userNote)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Button("Add to Favorites") {
                            viewModel.addToFavorites()
                        }
                        .buttonStyle(.borderedProminent)
                        
                    } else if let error = viewModel.errorMessage {
                        Text("Error: \(error)")
                    } else {
                        Text("Loading Space...")
                            .onAppear {
                                viewModel.loadData()
                            }
                    }
                    
                    // REQUIREMENT: ForEach with Reusable Subview
                    if !viewModel.favorites.isEmpty {
                        Text("Your Favorites")
                            .font(.title)
                            .padding(.top)
                        
                        ForEach(viewModel.favorites) { favPhoto in
                            PhotoCardView(photo: favPhoto)
                        }
                    }
                }
            }
            .navigationTitle("Today's Space")
        }
    }
}

struct PhotoCardView: View {
    let photo: APODItem
    // @Binding allows the child view to modify the parent's data (if we wanted to edit notes here)
    // Or we use it to simply pass data down effectively.
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(photo.title)
                .font(.headline)
                .foregroundColor(.white)
            Text(photo.date)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.blue.opacity(0.2)) // Spacey vibe
        .cornerRadius(10)
    }
}
