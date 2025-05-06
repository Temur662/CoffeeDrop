import Foundation

struct Cafe: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let address: String
    let city: String
    let state: String
    let zipCode: String
    let country: String
    let latitude: Double
    let longitude: Double
    let imageUrl: String
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "cafe_id"
        case name
        case description
        case address
        case city
        case state
        case zipCode = "zip_code"
        case country
        case latitude
        case longitude
        case imageUrl = "image_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
} 
