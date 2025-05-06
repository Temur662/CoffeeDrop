import SwiftUI

struct SocialTabView: View {
    @State private var isPresentingCreatePost = false
    
    var body: some View {
        NavigationView {
            FeedView()
                .navigationTitle(" ")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { isPresentingCreatePost = true }) {
                            Image(systemName: "plus")
                                .imageScale(.large)
                        }
                        .accessibilityLabel("Create Post")
                    }
                }
                .sheet(isPresented: $isPresentingCreatePost) {
                    CreatePostView()
                }
        }
    }
}

#Preview {
    SocialTabView()
}