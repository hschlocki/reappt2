import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?

    var body: some View {
        VStack {
            // Profile Picture and Info
            VStack {
                if let profileImageURL = viewModel.user?.profilePictureURL, let url = URL(string: profileImageURL) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(width: 100, height: 100)
                             .clipShape(Circle())
                             .onTapGesture {
                                 isImagePickerPresented = true
                             }
                    } placeholder: {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 100, height: 100)
                    }
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            isImagePickerPresented = true
                        }
                }
            }
            .padding(.bottom, 20)

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(viewModel.userPosts) { post in
                        // Post view implementation here
                    }
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchUserData()
            viewModel.fetchUserPosts()
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage, useCamera: .constant(false))
                .onDisappear {
                    if let selectedImage = selectedImage {
                        viewModel.uploadProfileImage(selectedImage)
                    }
                }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}
