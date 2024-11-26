import Foundation

struct Post: Identifiable {
    var id: String
    var author: String
    var content: String
    var imageURL: String?
    var timestamp: Date
}

struct User: Identifiable {
    var id: String
    var username: String
    var profilePictureURL: String?
    var followerCount: Int = 0
    var followingCount: Int = 0
}
