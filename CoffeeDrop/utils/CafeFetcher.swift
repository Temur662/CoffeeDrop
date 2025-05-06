import Foundation
import CoreLocation // Needed for CLLocationCoordinate2D

// Assume you have these structs defined elsewhere based on your Google Places API response
// Make sure they are Decodable and Identifiable as needed
struct GooglePlacesApiPlaceInfo: Equatable, Decodable, Identifiable {
    let id: String
    let displayName: DisplayName
    let rating: Double? // Rating might not exist for all places, make it optional
    let reviews: [Reviews]? // Reviews array might be nil or empty, make it optional
    let regularOpeningHours: RegularOpeningHours? // Opening hours might not be available, make it optional
    let formattedAddress: String? // formattedAddress might not always be present, make it optional
    let location: PlaceLocation // <<< Added location field

    // Conforming to Equatable
    static func == (lhs: GooglePlacesApiPlaceInfo, rhs: GooglePlacesApiPlaceInfo) -> Bool {
        lhs.id == rhs.id
    }
}

struct DisplayName: Equatable, Decodable {
    let text: String
    let languageCode: String
}

struct PlaceText: Decodable {
    let text: String
    // let languageCode: String?
}

struct AuthorAttribution: Decodable {
     let displayName: String
     let uri: String
     let photoUri: String
}

struct Period: Decodable {
    let open: DayTimePoint?
    let close: DayTimePoint?
}

struct DayTimePoint: Decodable {
    let day: Int // 0-6 Sunday-Saturday
    let hour: Int // 0-23
    let minute: Int // 0-59
}

struct Reviews: Decodable, Identifiable {
    let id = UUID() // Provide a default ID as Reviews in API might not have one
    let relativePublishTimeDescription: String
    let rating: CGFloat // Review rating is often int or double
    let text: PlaceText // Contains actual review text
    let authorAttribution: AuthorAttribution // Info about reviewer

    // Use CodingKeys if your struct names don't match JSON keys exactly
    // or to handle nested data that doesn't need its own struct type
     private enum CodingKeys: String, CodingKey {
         case relativePublishTimeDescription, rating, text, authorAttribution
     }
}

struct RegularOpeningHours : Decodable{
    // Add properties for opening hours (e.g., weekdayText: [String])
    // Make sure these properties are Equatable
    let openNow: Bool
    let periods: [Period]
    let weekdayDescriptions: [String]
}

struct PlaceLocation: Equatable, Decodable {
    let latitude: Double
    let longitude: Double
}

struct GooglePlacesApiResponse: Decodable {
    let places: [GooglePlacesApiPlaceInfo]? // Make places optional as the API might return no places
}

// MARK: - Separate ObservableObject for Fetching Cafes

class CafeFetcher: ObservableObject {
    // This published property will hold the fetched cafes.
    // Views observing this object will update when this array changes.
    @Published var cafes: [GooglePlacesApiPlaceInfo] = []
    @Published var isLoading = false // Optional: Add a loading state
    @Published var errorMessage: String? = nil // Optional: Add an error message property
    // Method to fetch cafes near a specific coordinate
    func fetchCafes(near coordinate: CLLocationCoordinate2D, numResults : Int) {
        isLoading = true
        errorMessage = nil // Clear previous errors

        let googleMapsKey = ProcessInfo.processInfo.environment["GOOGLE_PLACES_KEY"]!

        let jsonData: [String: Any] = [
            "includedTypes": [
                "cafe"
            ],
            "maxResultCount": numResults, // Increased result count
            "locationRestriction": [
                "circle": [
                    "center": [
                        "latitude": coordinate.latitude,
                        "longitude": coordinate.longitude
                    ],
                    "radius": 5000.0 // Increased radius (in meters)
                ]
            ],
             "languageCode": "en" // Specify language code
        ]

        guard let url = URL(string: "https://places.googleapis.com/v1/places:searchNearby") else {
            print("Invalid URL")
            isLoading = false
            errorMessage = "Invalid API URL."
            return
        }

        let headers = [
            "Content-Type": "application/json",
            "X-Goog-Api-Key": googleMapsKey,
            // Request necessary fields including geometry for location
            "X-Goog-FieldMask": "places.id,places.displayName,places.rating,places.reviews,places.regularOpeningHours,places.formattedAddress,places.location"
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = try? JSONSerialization.data(withJSONObject: jsonData, options: [])

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            // Use [weak self] to avoid retain cycles

            DispatchQueue.main.async { // Ensure UI updates and state changes are on the main thread
                self?.isLoading = false // Stop loading regardless of success or failure

                if let error = error {
                    print("API Request Error: \(error)")
                    self?.errorMessage = "Failed to fetch cafes: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    print("No data received from API")
                    self?.errorMessage = "No data received from API."
                    return
                }

                do {
                    let jsonDecoder = JSONDecoder()
                    let placesResponse = try jsonDecoder.decode(GooglePlacesApiResponse.self, from: data)
                    print("Successfully fetched \(placesResponse.places?.count ?? 0) places")

                    // Update the published property
                    self?.cafes = placesResponse.places ?? [] // Use nil coalescing to handle optional places array

                } catch {
                    print("Decoding error: \(error)")
                    self?.errorMessage = "Failed to decode API response: \(error.localizedDescription)"
                    if let decodingError = error as? DecodingError {
                        print("Decoding Error Details: \(decodingError)")
                    }
                     // Print raw data for debugging decoding issues
                     if let dataString = String(data: data, encoding: .utf8) {
                         print("Raw API Response Data:", dataString)
                     }
                }
            }
        }
        task.resume()
    }
}

/*
 Explanation:

 -   `class CafeFetcher: ObservableObject`: Defines a class that can be observed by SwiftUI views.
 -   `@Published var cafes: [GooglePlacesApiPlaceInfo] = []`: A published property. When its value changes, any view observing this `CafeFetcher` instance will be invalidated and re-rendered.
 -   `fetchCafes(near coordinate: CLLocationCoordinate2D)`: This method encapsulates the network request logic. It takes the user's coordinate as a parameter.
 -   `[weak self]`: Used in the `dataTask` completion handler to prevent a retain cycle between the task and the `CafeFetcher` instance.
 -   `DispatchQueue.main.async`: Ensures that the update to the `@Published cafes` property happens on the main thread, which is required for UI updates in SwiftUI.
 -   Error Handling: Added basic error handling for the network request and JSON decoding.
 -   Optional Properties: Updated `GooglePlacesApiResponse` to make `places` optional, as the API might return an empty or nil array. Also made properties in `GooglePlacesApiPlaceInfo` optional where the API documentation indicates they might be missing.
 */
