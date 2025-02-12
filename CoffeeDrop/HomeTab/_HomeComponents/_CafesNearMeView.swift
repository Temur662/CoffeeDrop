//
//  CafesNearMeView.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/8/25.
//

import SwiftUI

struct GooglePlacesApiPlaceInfo : Decodable, Identifiable {
    let displayName : DisplayName
    let rating : CGFloat
    let reviews : [Reviews]
    let regularOpeningHours : RegularOpeningHours
    let id : String
}
struct Reviews : Decodable {
    let name : String
    let rating : CGFloat
    let text : ReviewsText
}
struct ReviewsText : Decodable {
    let text : String
    let languageCode : String
}
struct DisplayName: Decodable {
    let text: String
    let languageCode: String
}

struct RegularOpeningHours : Decodable {
    let openNow : Bool
    let nextCloseTime : String
}

struct GooglePlacesApiResponse : Decodable {
    let places : [GooglePlacesApiPlaceInfo]
    
    enum CodingKeys: String, CodingKey {
           case places
    }
}


struct CafesNearMeView : View {
    @EnvironmentObject var userProfile: UserProfile // UserProfile Object
    @State private var cafesNearMe : [GooglePlacesApiPlaceInfo] = []
    
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
                ForEach(cafesNearMe){ place in
                    CafeNearMeCard(place: place, rating : place.rating)
                }
            }
        }
        //.onChange(of: userProfile.userLocation ){ oldstate, newState in
         //   GetCafesNearMe()
        //}
    }
    
    func GetCafesNearMe(){
        //  If no location just return else return with user info
        guard userProfile.userLocation != nil else { return }
        
        let googleMapsKey = ProcessInfo.processInfo.environment["GOOGLE_PLACES_KEY"]!
        //  Filter Api Results that match these queries
        print(userLatitude, userlongitude)
        let jsonData = [
            "includedTypes": [
                "cafe"  //  Return Cafes
            ],
            "maxResultCount": 3,    // Num results returned
            "locationRestriction": [
                "circle": [
                    "center": [
                        "latitude": userLatitude,
                        "longitude": userlongitude
                    ],
                    "radius": 1609.34
                ]
            ]
        ] as [String : Any]
        
        
        let data = try! JSONSerialization.data(withJSONObject: jsonData, options: [])
        
        let url = URL(string: "https://places.googleapis.com/v1/places:searchNearby")!
        let headers = [
            "Content-Type": "application/json",
            "X-Goog-Api-Key": googleMapsKey,
            "X-Goog-FieldMask": "places.id,places.displayName,places.rating,places.reviews,places.regularOpeningHours"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = data as Data
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let placesResponse = try jsonDecoder.decode(GooglePlacesApiResponse.self, from: data)
                    // Now you have your array of places
                    DispatchQueue.main.async { // Update UI on the main thread
                        cafesNearMe = placesResponse.places
                    }
                } catch {
                    print("Decoding error: \(error)") // Handle decoding errors!
                    if let decodingError = error as? DecodingError {
                        print("Decoding Error Details: \(decodingError)") // Print details
                    }
                }
            }
        }
        task.resume()
    }
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
                            Text("\(String(format:"%.1f", place.rating))")
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

                        HStack(spacing : 1){
                            if place.regularOpeningHours.openNow {
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

/*
 Cafe information i need:
    - cafe name
    - cafe is open
    - cafe closing hour
    - cafe image
    - cafe share link
    - cafe coordinates ( lat & log )
 */
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
