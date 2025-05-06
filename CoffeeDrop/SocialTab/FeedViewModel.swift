import Foundation
import SwiftUI

@MainActor
final class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var profiles: [Profile] = []
    @Published var cafes: [Cafe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasLoaded = false
    
    func loadMockDataIfNeeded() async {
        guard !hasLoaded else { return }
        hasLoaded = true
        await loadMockData()
    }
    
    func loadMockData() async {
        isLoading = true
        errorMessage = nil
        do {
            // Load posts
            guard let postsUrl = Bundle.main.url(forResource: "mockPosts", withExtension: "json") else {
                print("DEBUG: mockPosts.json not found in bundle")
                errorMessage = "Mock posts file not found."
                isLoading = false
                return
            }
            print("DEBUG: mockPosts.json found at \(postsUrl)")
            let postsData = try Data(contentsOf: postsUrl)
            print("DEBUG: Loaded postsData, size: \(postsData.count) bytes")
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let posts = try decoder.decode([Post].self, from: postsData)
            print("DEBUG: Decoded posts count: \(posts.count)")
            self.posts = posts
            // Load profiles
            if let profilesUrl = Bundle.main.url(forResource: "mockProfiles", withExtension: "json") {
                let profilesData = try Data(contentsOf: profilesUrl)
                let profiles = try decoder.decode([Profile].self, from: profilesData)
                print("DEBUG: