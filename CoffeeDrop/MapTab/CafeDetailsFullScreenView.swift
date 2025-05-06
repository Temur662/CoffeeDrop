//
//  CafeDetailsFullScreenView.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 5/6/25.
//
import SwiftUI

struct CafeDetailFullScreenView: View {
    let cafe: GooglePlacesApiPlaceInfo // Receive the selected cafe

    // Environment variable to dismiss the view if needed (e.g., for a custom close button)
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView { // Use a ScrollView for potentially long content
            VStack(alignment: .leading, spacing: 20) {
                // Header with Cafe Name and potentially a close button
                HStack {
                    Text(cafe.displayName.text)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    // Optional: Custom close button if navigation bar is hidden
                     Button("Done") {
                         dismiss()
                     }
                }

                // Rating and Reviews
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 4){
                        Text("\(String(format:"%.1f", cafe.rating ?? 0))")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)

                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(round(cafe.rating ?? 0)) ? "star.fill" : "star")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.yellow)
                        }
                    }
                    if let reviews = cafe.reviews, !reviews.isEmpty {
                        // Display review count or summary
                         Text("\(reviews.count) Reviews")
                             .font(.body)
                             .foregroundColor(.secondary)
                         // You might want to list individual reviews here
                         // ForEach(reviews) { review in Text(review.text ?? "") }
                    }
                }
                
                HStack(spacing: 4) {
                    // Iterate using enumerated() to get both index and element
                    ForEach(Array(cafe.types.prefix(4).enumerated()), id: \.element) { index, type in
                        Text(type)
                            .font(.caption) // Changed font to caption for types
                            .foregroundColor(.secondary) // Use secondary color

                        // Add a dot separator if it's not the last item
                        if index < cafe.types.count - 1 {
                            Text("•") // The dot separator
                                .font(.caption) // Match font size
                                .foregroundColor(.secondary) // Match color
                        }
                    }
                }
                Text(cafe.priceLevel.dollarSigns)
                    .font(.body)
                    .foregroundColor(.primary)
                // Address
                if let formattedAddress = cafe.formattedAddress {
                    VStack(alignment: .leading) {
                        Text("Address")
                            .font(.headline)
                        Text(formattedAddress)
                            .font(.body)
                    }
                }

                // Opening Hours
//                if let openingHours = cafe.regularOpeningHours {
//                    VStack(alignment: .leading) {
//                        Text("Opening Hours")
//                            .font(.headline)
//                        if let weekdayText = openingHours.weekdayDescriptions {
//                            ForEach(weekdayText, id: \.self) { dayHours in
//                                Text(dayHours)
//                                    .font(.body)
//                            }
//                        } else if openingHours.openNow != nil {
//                             Text(openingHours.openNow ?? false ? "Currently Open" : "Currently Closed")
//                                 .font(.body)
//                        }
//                    }
//                }

                // Add more details here as available in GooglePlacesApiPlaceInfo
                // Example: Photos, Phone Number, Website, etc.
                // if let photos = cafe.photos { ... }
                // if let phoneNumber = cafe.phoneNumber { ... }
                // if let website = cafe.website { ... }

                Spacer() // Push content to the top
            }
            .padding() // Add padding around the content inside the ScrollView
        }
        .navigationTitle(cafe.displayName.text) // Set navigation bar title
        .navigationBarTitleDisplayMode(.inline) // Use inline title mode
        // Optional: Add a custom background or styling
        // .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}
