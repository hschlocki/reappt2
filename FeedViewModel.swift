import SwiftUI
import FirebaseFirestore

class FeedViewModel: ObservableObject {
    @Published var posts = [Post]()
    private var db = Firestore.firestore()
    
    init() {
        fetchPosts()
    }
    
    func fetchPosts() {
        db.collection("posts")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error getting posts: \(error)")
                    return
                }
                
                self.posts = querySnapshot?.documents.compactMap { document in
                    let data = document.data()
                    let id = document.documentID
                    let author = data["author"] as? String ?? "Unknown"
                    let content = data["content"] as? String ?? ""
                    let imageURL = data["imageURL"] as? String
                    let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                    
                    return Post(id: id, author: author, content: content, imageURL: imageURL, timestamp: timestamp)
                } ?? []
            }
    }
}
