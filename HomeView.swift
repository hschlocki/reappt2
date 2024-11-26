import SwiftUI
import FirebaseFirestore

struct HomeView: View {
    @StateObject private var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.posts) { post in
                VStack(alignment: .leading, spacing: 10) {
                    Text(post.author)
                        .font(.headline)
                    Text(post.content)
                        .font(.body)
                    
                    if let imageURL = post.imageURL, let url = URL(string: imageURL) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity, maxHeight: 200)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    
                    Text(post.timestamp, style: .time)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
            }
            .navigationTitle("Feed")
        }
    }
}
