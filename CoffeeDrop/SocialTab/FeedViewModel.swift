import Foundation
import SwiftUI
import Supabase

@MainActor
final class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var profiles: [Profile] = []
    @Published var cafes: [Cafe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasLoaded = false
    
    func fetchAllFromSupabase() async {
        isLoading = true
        errorMessage = nil
        do {
            async let postsResult = fetchPostsFromSupabase()
            async let profilesResult = fetchProfilesFromSupabase()
            //async let cafesResult = fetchCafesFromSupabase()
            _ = try await (postsResult, profilesResult)
        } catch {
            print("DEBUG: Error fetching data from Supabase: \(error)")
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    private func fetchPostsFromSupabase() async throws {
        let response = try await Constants.API.supabaseClient
            .from("posts")
            .select()
            .order("created_at", ascending: false)
            .execute()
        let data = response.data
        
        // Print the raw JSON to see the exact date format
        if let jsonString = String(data: data, encoding: .utf8) {
            print("DEBUG: Raw JSON from Supabase:", jsonString)
        }
        
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZZZZZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        let posts = try decoder.decode([Post].self, from: data)
        self.posts = posts
    }
    
    private func fetchProfilesFromSupabase() async throws {
        let response = try await Constants.API.supabaseClient
            .from("profiles")
            .select()
            .execute()
        let data = response.data
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZZZZZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        let profiles = try decoder.decode([Profile].self, from: data)
        self.profiles = profiles
    }
    
    private func fetchCafesFromSupabase() async throws {
        let response = try await Constants.API.supabaseClient
            .from("cafes")
            .select()
            .execute()
        let data = response.data
        let cafes = try JSONDecoder().decode([Cafe].self, from: data)
        self.cafes = cafes
    }
    
    func addPost(_ post: Post) {
        posts.insert(post, at: 0)
    }
}
