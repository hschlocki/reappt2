import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var userPosts = [Post]()
    private var db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    func fetchUserData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.user = User(
                    id: userID,
                    username: data?["username"] as? String ?? "User",
                    profilePictureURL: data?["profilePictureURL"] as? String,
                    followerCount: data?["followerCount"] as? Int ?? 0,
                    followingCount: data?["followingCount"] as? Int ?? 0
                )
            } else {
                print("User data not found")
            }
        }
    }
    
    func fetchUserPosts() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("posts").whereField("author", isEqualTo: userID)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error getting posts: \(error)")
                    return
                }
                
                self.userPosts = querySnapshot?.documents.compactMap { document in
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
    
    func uploadProfileImage(_ image: UIImage) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let imageData = image.jpegData(compressionQuality: 0.5)
        let imageRef = storage.child("profile_pictures/\(userID).jpg")
        
        imageRef.putData(imageData!, metadata: nil) { _, error in
            if let error = error {
                print("Failed to upload profile image: \(error)")
                return
            }
            
            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Failed to retrieve profile image URL: \(error)")
                    return
                }
                
                guard let url = url else { return }
                
                self.db.collection("users").document(userID).updateData(["profilePictureURL": url.absoluteString]) { error in
                    if let error = error {
                        print("Failed to update profile image URL in Firestore: \(error)")
                    } else {
                        self.fetchUserData()
                    }
                }
            }
        }
    }
}
