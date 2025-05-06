import Foundation
import PostgREST

struct Post: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let cafeId: UUID
    let title: String
    let content: String
    let mediaUrl: String
    let isDraft: Bool
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "post_id"
        case userId = "user_id"
        case cafeId = "cafe_id"
        case title
        case content
        case mediaUrl = "media_url"
        case isDraft = "is_draft"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
} 
