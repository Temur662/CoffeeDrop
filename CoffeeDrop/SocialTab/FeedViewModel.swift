import Foundation
import SwiftUI

@MainActor
final class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var profiles: [Profile] = []
    @Published var cafes: [Cafe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadMockData() async {
        isLoading = true
        errorMessage = nil
        do {
            // Load posts
            guard let postsUrl = Bundle.main.url(forResource: "mockPosts", withExtension: "json") else {
                errorMessage = "Mock posts file not found."
                isLoading = false
                return
            }
            let postsData = try Data(contentsOf: postsUrl)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let posts = try decoder.decode([Post].self, from: postsData)
            self.posts = posts
            // Load profiles
            if let profilesUrl = Bundle.main.url(forResource: "mockProfiles", withExtension: "json") {
                let profilesData = try Data(contentsOf: profilesUrl)
                let profiles = try decoder.decode([Profile].self, from: profilesData)
                self.profiles = profiles
            }
            // Load cafes
            if let cafesUrl = Bundle.main.url(forResource: "mockCafes", withExtension: "json") {
                let cafesData = try Data(contentsOf: cafesUrl)
                let cafes = try decoder.decode([Cafe].self, from: cafesData)
                self.cafes = cafes
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

