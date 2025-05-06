//
//  CafesNearMeView.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/8/25.
//

import SwiftUI
import MapKit
//struct PlaceLocation: Decodable {
//    let latitude: Double
//    let longitude: Double
//}
//
//struct DisplayName: Decodable {
//    let text: String
//    // let languageCode: String? // Often included
//}
//
//struct Period: Decodable {
//    let open: DayTimePoint?
//    let close: DayTimePoint?
//}
//
//struct DayTimePoint: Decodable {
//    let day: Int // 0-6 Sunday-Saturday
//    let hour: Int // 0-23
//    let minute: Int // 0-59
//}
//
//struct RegularOpeningHours: Decodable {
//    let openNow: Bool
//    let periods: [Period]
//    let weekdayDescriptions: [String]
//}
//
//struct PlaceText: Decodable {
//    let text: String
//    // let languageCode: String?
//}
//
//struct AuthorAttribution: Decodable {
//     let displayName: String
//     let uri: String
//     let photoUri: String
//}
//
//
//// Reviews might have more structure
//struct Reviews: Decodable, Identifiable {
//    let id = UUID() // Provide a default ID as Reviews in API might not have one
//    let relativePublishTimeDescription: String
//    let rating: CGFloat // Review rating is often int or double
//    let text: PlaceText // Contains actual review text
//    let authorAttribution: AuthorAttribution // Info about reviewer
//
//    // Use CodingKeys if your struct names don't match JSON keys exactly
//    // or to handle nested data that doesn't need its own struct type
//     private enum CodingKeys: String, CodingKey {
//         case relativePublishTimeDescription, rating, text, authorAttribution
//     }
//}
//
//// --- Main Place Info Struct ---
//// Updated to include 'location' and 'formattedAddress'
//// Made optional properties for fields that might not always be present (rating, reviews, hours, address)
//struct GooglePlacesApiPlaceInfo: Equatable, Decodable, Identifiable {
//    let id: String
//    let displayName: DisplayName
//    let rating: Double // Rating might not exist for all places
//    let reviews: [Reviews] // Reviews array might be nil or empty
//    let regularOpeningHours: RegularOpeningHours // Opening hours might not be available
//    let formattedAddress: String // Requesting this field too
//    let location: PlaceLocation // <<< Added location field
//    static func == (lhs: GooglePlacesApiPlaceInfo, rhs: GooglePlacesApiPlaceInfo) -> Bool {
//       // For types with a unique identifier like 'id', comparing IDs is usually sufficient
//       lhs.id == rhs.id
//   }
//}
//
//// --- Overall API Response Structure ---
//struct GooglePlacesApiResponse: Decodable {
//    let places: [GooglePlacesApiPlaceInfo]
//    // You might get other fields like nextPageToken if there are more results
//}



struct CafesNearMeView : View {
    @EnvironmentObject var userProfile: UserProfile // UserProfile Object
    @State private var cafesNearMe : [GooglePlacesApiPlaceInfo] = []
    @StateObject private var cafeFetcher = CafeFetcher()
    @StateObject private var locationManagerModel = ContentViewModel()
    var userLatitude : CGFloat {
        let region = userProfile.userLocation?.region
        return region?.center.latitude ?? 0
    }
    var userlongitude : CGFloat {
        let region = userProfile.userLocation?.region
        return region?.center.longitude ?? 0
    }
    
    var body: some View {
        ScrollView(.horizontal){
            HStack(spacing : 8){
                ForEach(cafeFetcher.cafes){ place in
                    CafeNearMeCard(place: place, rating : place.rating ?? 0)
                }
            }
        }
        .onAppear {
            locationManagerModel.checkIfLocationServicesEnabled()
            // Trigger initial fetch if location is already available on appear
           if let location = userProfile.userLocation {
               cafeFetcher.fetchCafes(near: CLLocationCoordinate2D(latitude :location.region?.center.latitude ?? 0, longitude: location.region?.center.longitude ?? 0), numResults: 3)
           }
        }
        .onChange(of: userProfile.userLocation ){ oldstate, newState in
            if let location = newState {
                 // Call the fetcher's method with the new location
                cafeFetcher.fetchCafes(near: CLLocationCoordinate2D(latitude :location.region?.center.latitude ?? 0, longitude: location.region?.center.longitude ?? 0), numResults: 3)
            }
        }
    }
    
//    func GetCafesNearMe(){
//        //  If no location just return else return with user info
//        guard userProfile.userLocation != nil else { return }
//        print("Running Get Cafe Near Me")
//        let googleMapsKey = ProcessInfo.processInfo.environment["GOOGLE_PLACES_KEY"]!
//        //  Filter Api Results that match these queries
//        print(userLatitude, userlongitude)
//        let jsonData = [
//            "includedTypes": [
//                "cafe"  //  Return Cafes
//            ],
//            "maxResultCount": 3,    // Num results returned
//            "locationRestriction": [
//                "circle": [
//                    "center": [
//                        "latitude": userLatitude,
//                        "longitude": userlongitude
//                    ],
//                    "radius": 1609.34
//                ]
//            ]
//        ] as [String : Any]
//        
//        
//        let data = try! JSONSerialization.data(withJSONObject: jsonData, options: [])
//        
//        let url = URL(string: "https://places.googleapis.com/v1/places:searchNearby")!
//        let headers = [
//            "Content-Type": "application/json",
//            "X-Goog-Api-Key": googleMapsKey,
//            "X-Goog-FieldMask": "places.id,places.displayName,places.rating,places.reviews,places.regularOpeningHours,places.formattedAddress,places.location"
//        ]
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.allHTTPHeaderFields = headers
//        request.httpBody = data as Data
//        
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                print(error)
//            } else if let data = data {
//                do {
//                    let jsonDecoder = JSONDecoder()
//                    let placesResponse = try jsonDecoder.decode(GooglePlacesApiResponse.self, from: data)
//                    // Now you have your array of places
//                    DispatchQueue.main.async { // Update UI on the main thread
//                        cafesNearMe = placesResponse.places
//                    }
//                } catch {
//                    print("Decoding error: \(error)") // Handle decoding errors!
//                    if let decodingError = error as? DecodingError {
//                        print("Decoding Error Details: \(decodingError)") // Print details
//                    }
//                }
//            }
//        }
//        task.resume()
//    }
}

struct CafeNearMeCard : View {
    let place : GooglePlacesApiPlaceInfo
    let rating : CGFloat
    var body : some View {
        VStack(spacing:0){
            Rectangle()
                .frame(width: 135, height: 140)
                .foregroundColor(.gray)
                .clipShape(.rect(
                    topLeadingRadius: 20,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 20
                ))
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 135, height: 80)
                .background(Color(red: 0.54, green: 0.32, blue: 0.16))
                .clipShape(.rect(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 20,
                    bottomTrailingRadius: 20,
                    topTrailingRadius: 0
                ))
                .overlay(
                    VStack{
                        HStack{
                            Text("\(String(format:"%.1f", place.rating ?? 0))")
                                .font(.caption)
                                .foregroundStyle(Color.white)
                            ForEach(0..<5){ item in
                               
                                    Star(corners: 5, smoothness: 0.45)
                                        .fill(Color.gray)
                                        .frame(width: 10, height: 8.8)
                                        .opacity(0.8)
                            }
                            Spacer()
                        }
                        .padding(.leading)

                        HStack(spacing : 4){ // Reduced spacing
                        // Check if openNow is true and nextCloseTime is available
                        if place.regularOpeningHours?.openNow == true,
                           let nextCloseTime = place.regularOpeningHours?.nextCloseTime {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 6, height: 6) // Increased size slightly
                            Text("Open")
                                .foregroundStyle(Color.green)
                                .font(.caption)
                            // Corrected: Unwrapped nextCloseTime before concatenation
                            if let formattedTime2 = formatISO8601TimeTo12HourClock(isoString: nextCloseTime) {
                                Text("~ " + formattedTime2)
                                    .foregroundStyle(.white) // Use secondary color for time
                                    .font(.caption)
                            }
                        } else {
                            // If openNow is false
                            Circle()
                                .fill(Color.green)
                                .frame(width: 6, height: 6)
                            Text("Open 24/7")
                                .foregroundStyle(Color.green)
                                .font(.caption)
                        }
                        Spacer() // Pushes content to the left
                    }
                        .padding(.leading)
                        HStack{
                            Text("\(place.displayName.text)")
                                .foregroundStyle(Color.white)
                                .font(.caption)
                            Spacer()
                            Spacer()
                        }
                        .padding(.leading)
                    }
                )
        }
    }
}

struct Star: Shape {
    // store how many corners the star has, and how smooth/pointed it is
    let corners: Int
    let smoothness: Double

    func path(in rect: CGRect) -> Path {
        // ensure we have at least two corners, otherwise send back an empty path
        guard corners >= 2 else { return Path() }

        // draw from the center of our rectangle
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)

        // start from directly upwards (as opposed to down or to the right)
        var currentAngle = -CGFloat.pi / 2

        // calculate how much we need to move with each star corner
        let angleAdjustment = .pi * 2 / Double(corners * 2)

        // figure out how much we need to move X/Y for the inner points of the star
        let innerX = center.x * smoothness
        let innerY = center.y * smoothness

        // we're ready to start with our path now
        var path = Path()

        // move to our initial position
        path.move(to: CGPoint(x: center.x * cos(currentAngle), y: center.y * sin(currentAngle)))

        // track the lowest point we draw to, so we can center later
        var bottomEdge: Double = 0

        // loop over all our points/inner points
        for corner in 0..<corners * 2  {
            // figure out the location of this point
            let sinAngle = sin(currentAngle)
            let cosAngle = cos(currentAngle)
            let bottom: Double

            // if we're a multiple of 2 we are drawing the outer edge of the star
            if corner.isMultiple(of: 2) {
                // store this Y position
                bottom = center.y * sinAngle

                // …and add a line to there
                path.addLine(to: CGPoint(x: center.x * cosAngle, y: bottom))
            } else {
                // we're not a multiple of 2, which means we're drawing an inner point

                // store this Y position
                bottom = innerY * sinAngle

                // …and add a line to there
                path.addLine(to: CGPoint(x: innerX * cosAngle, y: bottom))
            }

            // if this new bottom point is our lowest, stash it away for later
            if bottom > bottomEdge {
                bottomEdge = bottom
            }

            // move on to the next corner
            currentAngle += angleAdjustment
        }

        // figure out how much unused space we have at the bottom of our drawing rectangle
        let unusedSpace = (rect.height / 2 - bottomEdge) / 2

        // create and apply a transform that moves our path down by that amount, centering the shape vertically
        let transform = CGAffineTransform(translationX: center.x, y: center.y + unusedSpace)
        return path.applying(transform)
    }
}

func formatISO8601TimeTo12HourClock(isoString: String) -> String? {
    // 1. Create a DateFormatter to parse the input ISO 8601 string.
    // Using "en_US_POSIX" locale is recommended for parsing fixed-format date strings.
    let inputFormatter = DateFormatter()
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    // The format string matches "YYYY-MM-DDTHH:mm:ssZ"
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    // Set the input time zone to UTC because 'Z' indicates Zulu time (UTC)
    inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)

    // 2. Attempt to parse the input string into a Date object.
    guard let date = inputFormatter.date(from: isoString) else {
        // Return nil if the string cannot be parsed
        print("Error: Could not parse date string '\(isoString)'")
        return nil
    }

    // 3. Create a second DateFormatter to format the Date object into the desired time string.
    let outputFormatter = DateFormatter()
    // Set the locale to the user's current locale for appropriate AM/PM format
    outputFormatter.locale = Locale.current
    // Set the format string for 12-hour time with AM/PM (e.g., "3 PM", "6 AM")
    outputFormatter.dateFormat = "h a"

    // *** Set the time zone for the OUTPUT formatter to Eastern Time ***
    // "America/New_York" is a standard identifier that handles EST/EDT automatically
    guard let easternTimeZone = TimeZone(identifier: "America/New_York") else {
        print("Error: Could not create TimeZone for America/New_York")
        return nil // Should not happen for a standard identifier
    }
    outputFormatter.timeZone = easternTimeZone

    // 4. Format the Date object into the output string in the Eastern Time Zone.
    let timeString = outputFormatter.string(from: date)

    return timeString
}
