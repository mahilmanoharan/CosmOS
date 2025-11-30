import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    @State private var userNote: String = ""
    @State private var selectedHemisphere: String = "Northern"
    @State private var selectedDate: Date = Date()
    
    let hemispheres = ["Northern", "Southern"]
    
    var body: some View {
        NavigationView {
            ZStack {
                // COSMIC BACKGROUND
                LinearGradient(gradient: Gradient(colors: [Color.black, Color(red: 0.1, green: 0.1, blue: 0.2)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // CONTROLS
                        VStack(spacing: 15) {
                            Text("Mission Control")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            // DATE PICKER
                            DatePicker("Travel to Date", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .accentColor(.purple)
                                .onChange(of: selectedDate) { newDate in
                                    // When date changes, fetch new data!
                                    viewModel.loadData(for: newDate)
                                }

                            Picker("Hemisphere", selection: $selectedHemisphere) {
                                ForEach(hemispheres, id: \.self) { hemisphere in
                                    Text(hemisphere)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            Text(selectedHemisphere == "Northern" ? "🔭 Visible: Ursa Major & Cassiopeia" : "🔭 Visible: Southern Cross & Centaurus")
                                .font(.caption)
                                .foregroundColor(.cyan)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                        // THE PHOTO
                        if let photo = viewModel.currentPhoto {
                            VStack(alignment: .leading) {
                                Text(photo.title)
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(.bottom, 5)

                                AsyncImage(url: URL(string: photo.url)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ZStack {
                                        Color.black
                                        ProgressView()
                                    }
                                    .frame(height: 250)
                                }
                                .cornerRadius(12)
                                .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 5) // Glowing shadow
                                
                                Text(photo.explanation)
                                    .font(.body)
                                    .foregroundColor(.gray)
                                    .padding(.top)
                                
                                // INPUT NOTE
                                TextField("Captain's Log (Notes)...", text: $userNote)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.vertical)
                                    .colorScheme(.light) // Keep text field readable
                                
                                Button(action: {
                                    viewModel.addToFavorites()
                                }) {
                                    HStack {
                                        Image(systemName: "star.fill")
                                        Text("Save to Database")
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(15)
                            .padding(.horizontal)
                            
                        } else if let error = viewModel.errorMessage {
                            Text("Signal Lost: \(error)")
                                .foregroundColor(.red)
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                        } else {
                            ProgressView("Establishing Link...")
                                .foregroundColor(.white)
                                .onAppear {
                                    viewModel.loadData() // Load today initially
                                }
                        }
                        
                        // FAVORITES
                        if !viewModel.favorites.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Database Archives")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(.leading)
                                
                                ForEach(viewModel.favorites) { photo in
                                    PhotoCardView(photo: photo)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("CosmOS")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark) // Forces Dark Mode
        }
    }
}

struct PhotoCardView: View {
    let photo: APODItem
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: photo.url)) { image in
                image.resizable()
                    .scaledToFill() // Fills the square perfectly
            } placeholder: {
                Color.gray
            }
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            .clipped() // Cuts off the overflow
            
            VStack(alignment: .leading) {
                Text(photo.title)
                    .font(.headline)
                    .foregroundColor(.white) // White text
                    .lineLimit(1)
                Text(photo.date)
                    .font(.caption)
                    .foregroundColor(.cyan) // Sci-fi blue text
            }
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.1)) // Subtle transparent background
        .cornerRadius(10)
    }
}
