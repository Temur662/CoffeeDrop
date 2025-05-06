import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
            } else {
                ScrollView {
                    LazyVStack(spacing: 24) {
                        ForEach(viewModel.posts) { post in
                            PostCardWrapper(post: post, profiles: viewModel.profiles, cafes: viewModel.cafes)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .task {
            await viewModel.fetchAllFromSupabase()
        }
    }
}

struct PostCardWrapper: View {
    let post: Post
    let profiles: [Profile]
    let cafes: [Cafe]

    var body: some View {
        let user = profiles.first { $0.id.uuidString == "\(post.userId)" }
        let cafe = cafes.first { $0.id.uuidString == "\(post.cafeId)" }
        PostCardView(post: post, user: user, cafe: cafe)
    }
}

struct PostCardView: View {
    let post: Post
    let user: Profile?
    let cafe: Cafe?
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Circle()
                    .stroke(Color.secondary, lineWidth: 1)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.secondary)
                            .padding(6)
                    )
                VStack(alignment: .leading, spacing: 2) {
                    Text(user?.userName ?? "Unknown User")
                        .font(.headline)
                    Text(post.title)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                Spacer()
            }
            Text(post.content)
                .font(.body)
            if let cafe = cafe {
                Text("at \(cafe.name)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            HStack(spacing: 12) {
                if let url = URL(string: post.mediaUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 140, height: 140)
                            .clipped()
                            .cornerRadius(12)
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 140, height: 140)
                    }
                }
                // Placeholder for map or other image
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 140, height: 140)
                    .overlay(
                        Image(systemName: "map")
                            .foregroundColor(.secondary)
                    )
            }
            HStack(spacing: 32) {
                Button(action: {}) {
                    Image(systemName: "hand.thumbsup")
                        .imageScale(.large)
                }
                Button(action: {}) {
                    Image(systemName: "bubble.right")
                        .imageScale(.large)
                }
                Spacer()
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}
