//
//  Map.swift
//  CoffeeDrop
//  Root View of the Map Tab
//  Created by Temurbek Sayfutdinov on 2/1/25.
//

import SwiftUI
import MapKit
import CoreLocation // Import CoreLocation for location services

struct MapTab: View {
   @EnvironmentObject var userProfile: UserProfile // UserProfile Object
   var animation: Namespace.ID

   // Use StateObject to create and manage the lifecycle of the CafeFetcher
   @StateObject private var cafeFetcher = CafeFetcher()

   // Assuming ContentViewModel is your LocationManagerModel
   @StateObject private var locationManagerModel = ContentViewModel()

   // State variable to hold the ID of the currently selected cafe (for Map selection binding)
   @State private var selectedCafeID: String?

   // State variable to hold the currently selected cafe object (for the info card)
   // This will be derived from the selectedCafeID and the fetched cafes
   @State private var selectedCafe: GooglePlacesApiPlaceInfo? = nil
    
    var userLatitude : CGFloat {
        let region = userProfile.userLocation?.region
        return region?.center.latitude ?? 0
    }
    var userlongitude : CGFloat {
        let region = userProfile.userLocation?.region
        return region?.center.longitude ?? 0
    }

    var body: some View {
          NavigationStack {
              ZStack(alignment: .bottom) { // Use ZStack to layer the map and the info card
                  Map(position: $locationManagerModel.cameraPosition, selection: $selectedCafeID) {
                      UserAnnotation()
                          // When the marker is tapped, it will automatically set the selected item
                      ForEach(cafeFetcher.cafes, id: \.id){ cafe in
                          Marker(cafe.displayName.text, coordinate: CLLocationCoordinate2D(latitude: cafe.location.latitude, longitude: cafe.location.longitude))
                              .tag(cafe.id)
                      }
                  }
                  .mapControls {
                      MapUserLocationButton()
                      MapCompass()
                      MapScaleView()
                  }
                  .mapStyle(.standard) // Or .hybrid, .satellite
                  .matchedGeometryEffect(id: "Map", in: animation)
                  .navigationBarHidden(true) // Hide the Navigation Bar
                  .onAppear {
                      locationManagerModel.checkIfLocationServicesEnabled()
                      // Trigger initial fetch if location is already available on appear
                     if let location = userProfile.userLocation {
                          cafeFetcher.fetchCafes(near: CLLocationCoordinate2D(latitude :location.region?.center.latitude ?? 0, longitude: location.region?.center.longitude ?? 0), numResults: 6)
                     }
                  }
                  // Trigger fetching cafes when the user's actual location changes
                  .onChange(of: userProfile.userLocation) { oldState, newState in
                      if let location = newState {
                           // Call the fetcher's method with the new location
                           cafeFetcher.fetchCafes(near: CLLocationCoordinate2D(latitude :location.region?.center.latitude ?? 0, longitude: location.region?.center.longitude ?? 0),numResults: 6)
                      }
                  }
                  // Observe changes to the selectedCafeID and update the selectedCafe object
                  .onChange(of: selectedCafeID) { oldID, newID in
                      if let id = newID {
                          // Find the cafe in the cafeFetcher's cafes array that matches the selected ID
                          selectedCafe = cafeFetcher.cafes.first(where: { $0.id == id })
                      } else {
                          // If the ID is nil, deselect the cafe
                          selectedCafe = nil
                      }
                  }
                  // Observe changes to the fetched cafes and clear selected cafe if it's no longer in the list
                  .onChange(of: cafeFetcher.cafes) { oldCafes, newCafes in
                      // If the selected cafe is no longer in the updated list, deselect it
                      if let currentSelectedCafe = selectedCafe, !newCafes.contains(currentSelectedCafe) {
                          selectedCafe = nil
                          selectedCafeID = nil // Also clear the ID
                      }
                  }
                  

                  // The Info Card View
                  if let cafe = selectedCafe {
                      CafeInfoCardView(cafe: cafe)
                          .transition(.move(edge: .bottom)) // Add a transition
                          .padding() // Add some padding around the card
                          .background(.ultraThinMaterial) // Add a translucent background
                          .cornerRadius(10) // Rounded corners
                          .shadow(radius: 10) // Add a shadow
                          .padding(.horizontal) // Horizontal padding from the screen edges
                          .animation(.easeInOut, value: selectedCafe) // Animate changes to selectedCafe
                          .safeAreaPadding(.bottom, 15) // Adjust the value (e.g., 15) as needed for spacing

                  }
              }
          }
          .edgesIgnoringSafeArea(.vertical)
      }
}


// A separate View for the Info Card
struct CafeInfoCardView: View {
    let cafe: GooglePlacesApiPlaceInfo // Pass the selected cafe to this view

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Rectangle()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
                .clipShape(.rect(
                    topLeadingRadius: 20,
                    bottomLeadingRadius: 20,
                    bottomTrailingRadius: 20,
                    topTrailingRadius: 20
                ))

            VStack(alignment: .leading, spacing: 8){
                Text(cafe.displayName.text)
                    .font(.headline)
                HStack{
                    Text("\(String(format:"%.1f", cafe.rating ?? 0))")
                        .font(.caption)
                        .foregroundStyle(Color.white)
                    ForEach(0..<5){ item in
                       
                            Star(corners: 5, smoothness: 0.45)
                                .fill(Color.gray)
                                .frame(width: 10, height: 8.8)
                                .opacity(0.8)
                    }
                }
                HStack(spacing : 1){
                    if cafe.regularOpeningHours?.openNow ?? false && ((cafe.regularOpeningHours?.openNow) != nil) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 3, height: 3)
                        Text("Open")
                            .foregroundStyle(Color.green)
                            .font(.caption)
                        Text("~ Xpm")
                            .foregroundStyle(Color.white)
                            .font(.caption)
                        Spacer()
                    }
                }
            }

            // Add more details here as available in GooglePlacesApiPlaceInfo
            // Example:
            // if let rating = cafe.rating {
            //     Text("Rating: \(rating, specifier: "%.1f")")
            //         .font(.subheadline)
            // }
            // Text("Latitude: \(cafe.geometry.location.latitude, specifier: "%.4f")")
            // Text("Longitude: \(cafe.geometry.location.longitude, specifier: "%.4f")")

            // Add a button or gesture to dismiss the card if needed
             // Button("Close") {
             //     // You would need a binding or environment variable to dismiss
             // }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading) // Make the card fill the width
    }
}




//func GetCafesNearMe(){
//    //  If no location just return else return with user info
//    guard userProfile.userLocation != nil else { return }
//    
//    let googleMapsKey = ProcessInfo.processInfo.environment["GOOGLE_PLACES_KEY"]!
//    //  Filter Api Results that match these queries
//    print(userLatitude, userlongitude)
//    let jsonData = [
//        "includedTypes": [
//            "cafe"  //  Return Cafes
//        ],
//        "maxResultCount": 3,    // Num results returned
//        "locationRestriction": [
//            "circle": [
//                "center": [
//                    "latitude": userLatitude,
//                    "longitude": userlongitude
//                ],
//                "radius": 1609.34
//            ]
//        ]
//    ] as [String : Any]
//    
//    
//    let data = try! JSONSerialization.data(withJSONObject: jsonData, options: [])
//    
//    let url = URL(string: "https://places.googleapis.com/v1/places:searchNearby")!
//    let headers = [
//        "Content-Type": "application/json",
//        "X-Goog-Api-Key": googleMapsKey,
//        "X-Goog-FieldMask": "places.id,places.displayName,places.rating,places.reviews,places.regularOpeningHours,places.formattedAddress,places.location"
//    ]
//    
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    request.allHTTPHeaderFields = headers
//    request.httpBody = data as Data
//    
//    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//        if let error = error {
//            print(error)
//        } else if let data = data {
//            do {
//                let jsonDecoder = JSONDecoder()
//                let placesResponse = try jsonDecoder.decode(GooglePlacesApiResponse.self, from: data)
//                // Now you have your array of places
//                DispatchQueue.main.async { // Update UI on the main thread
//                    cafesNearMe = placesResponse.places
//                }
//            } catch {
//                print("Decoding error: \(error)") // Handle decoding errors!
//                if let decodingError = error as? DecodingError {
//                    print("Decoding Error Details: \(decodingError)") // Print details
//                }
//            }
//        }
//    }
//    task.resume()
//}
