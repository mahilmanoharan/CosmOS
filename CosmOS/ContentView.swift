import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    @State private var userNote: String = ""
    @State private var selectedHemisphere: String = "Northern"
    @State private var selectedDate: Date = Date()
    @State private var isDescriptionExpanded: Bool = false
    
    let hemispheres = ["Northern", "Southern"]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background: Deep Space Gradient
                LinearGradient(gradient: Gradient(colors: [Color.black, Color(red: 0.05, green: 0.05, blue: 0.1)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // Top Section. Shows like what you can see in the sky from what hemisphere of earth you are on.
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Text("Where are you observing from?")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                            
                            Text("Your location on Earth determines which stars are visible in your night sky.")
                                .font(.footnote)
                                .foregroundColor(.gray)
                            
                            Picker("Hemisphere", selection: $selectedHemisphere) {
                                ForEach(hemispheres, id: \.self) { hemisphere in
                                    Text(hemisphere)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.top, 5)
                            
                            // Dynamic advice based on location. Work in progress...
                            HStack {
                                Image(systemName: "binoculars.fill")
                                    .foregroundColor(.cyan)
                                Text(selectedHemisphere == "Northern" ? "Look North: Ursa Major is visible tonight." : "Look South: The Southern Cross is visible tonight.")
                                    .font(.caption)
                                    .foregroundColor(.cyan)
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                        // The main part. Shows the picture and the description pulled from nasa api.
                        VStack(alignment: .leading, spacing: 10) {

                            // DATE PICKER
                            HStack {
                                Spacer()
                                DatePicker("", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                                    .labelsHidden()
                                    .accentColor(.cyan)
                                    .onChange(of: selectedDate) { newDate in
                                        viewModel.loadData(for: newDate)
                                    }
                            }
                            .padding(.horizontal)

                            if let photo = viewModel.currentPhoto {
                                VStack(alignment: .leading) {
                                    // Image
                                    AsyncImage(url: URL(string: photo.url)) { image in
                                        image.resizable().scaledToFit()
                                    } placeholder: {
                                        ZStack {
                                            Color.black.frame(height: 250)
                                            ProgressView()
                                        }
                                    }
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                                    
                                    Text(photo.title)
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding(.top, 10)
                                    
                                    // DESCRIPTION TEXT
                                    VStack(alignment: .leading) {
                                        Text(photo.explanation)
                                        .font(.body)
                                        .foregroundColor(.gray)
                                        // Shows full description if clicked on.
                                        .lineLimit(isDescriptionExpanded ? nil : 3)
                                        .animation(.easeInOut, value: isDescriptionExpanded) // Smooth slide
                                    }
                                            .onTapGesture {
                                            // Cool animation that shows up when expanded or made smaller.
                                            withAnimation {
                                                isDescriptionExpanded.toggle()
                                                }
                                            }
                                    
                                    Divider().background(Color.gray)
                                    
                                    // Add your thoughts on the phenomena!
                                    TextField("Write a log entry...", text: $userNote)
                                        .padding()
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(8)
                                        .foregroundColor(.white)
                                    
                                    // Favorite button
                                    Button(action: {
                                        viewModel.addToFavorites(note: userNote) // Pass the note!
                                        userNote = "" // Clear the box
                                    }) {
                                        HStack {
                                            Image(systemName: "plus")
                                            Text("Add to Favorites")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray, lineWidth: 1) // Classy border
                                        )
                                        .foregroundColor(.white)
                                    }
                                    .padding(.top, 5)
                                }
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(15)
                                .padding(.horizontal)
                            } else {
                                ProgressView()
                                    .onAppear { viewModel.loadData() }
                                    .frame(maxWidth: .infinity, minHeight: 200)
                            }
                        }
                        
                        // Archive or Favorites
                        if !viewModel.favorites.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Your Archives")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(.leading)
                                
                                ForEach(viewModel.favorites) { photo in
                                    // NAVIGATION LINK: Makes items clickable
                                    NavigationLink(destination: DetailView(photo: photo)) {
                                        PhotoCardView(photo: photo)
                                        .padding(.horizontal)
                                    }
                                    // Long Press to Delete
                                    .contextMenu {
                                        Button(role: .destructive) {
                                                withAnimation {
                                                viewModel.removeFavorite(photo: photo)
                                                }
                                            } label: {
                                        Label("Remove", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                            .padding(.bottom, 50)
                        }
                    }
                }
            }
            .navigationTitle("CosmOS")
            .navigationBarHidden(true) // Hide default ugly nav bar
        }
        .preferredColorScheme(.dark)
    }
}

// The mini cards that represent your favorited item under the archives section.
struct PhotoCardView: View {
    let photo: APODItem
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: photo.url)) { image in
                image.resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray
            }
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            .clipped() // Cuts off the overflow
            
            VStack(alignment: .leading) {
                Text(photo.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                Text(photo.date)
                    .font(.caption)
                    .foregroundColor(.cyan)
            }
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}
