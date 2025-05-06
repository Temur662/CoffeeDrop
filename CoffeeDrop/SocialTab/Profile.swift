import Foundation

struct Profile: Identifiable, Codable {
    let id: UUID // user_id
    let userName: String?
    let email: String?
    let phoneNumber: String?
    let createdAt: Date
    let updatedAt: Date?
    let isAuth: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case userName = "user_name"
        case email
        case phoneNumber = "phone_number"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isAuth = "is_auth"
    }
} 
