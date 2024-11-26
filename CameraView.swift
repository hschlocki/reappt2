import SwiftUI
import Firebase
import FirebaseStorage
import UIKit


struct CameraView: View {
    @State private var selectedImage: UIImage?
    @State private var content: String = ""
    @State private var uploadStatusMessage: String = ""
    @State private var isImagePickerPresented = false
    @State private var useCamera = false
    private let storage = Storage.storage().reference()
    private let db = Firestore.firestore()
    
    var body: some View {
        VStack {
            TextField("Write something...", text: $content)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .padding()
            }
            
            Button("Choose Image from Gallery") {
                useCamera = false
                isImagePickerPresented = true
            }
            .padding()
            
            Button("Take Photo with Camera") {
                useCamera = true
                isImagePickerPresented = true
            }
            .padding()
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage, useCamera: $useCamera)
            }
            
            Button("Post") {
                uploadPost()
            }
            .padding()
            
            Text(uploadStatusMessage)
                .foregroundColor(.green)
                .padding()
        }
    }
    
    func uploadPost() {
        // Post upload logic
    }
}
