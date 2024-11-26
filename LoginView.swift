import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// LoginView.swift
struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @ObservedObject var authService = AuthenticationService()
    @State private var loginStatusMessage = ""

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top)

            Button("Sign In") {
                authService.signIn(email: email, password: password) { success in
                    if success {
                        loginStatusMessage = "Login successful"
                    } else {
                        loginStatusMessage = "Login failed. Please try again."
                    }
                }
            }
            .padding()

            Button("Sign Up") {
                authService.signUp(email: email, password: password, username: username) { success in
                    if success {
                        loginStatusMessage = "Sign up successful"
                    } else {
                        loginStatusMessage = "Sign up failed. Please try again."
                    }
                }
            }
            .padding()

            Text(loginStatusMessage)
                .foregroundColor(.red)
                .padding()

            if authService.user != nil {
                NavigationLink(destination: ContentView()) {
                    Text("Continue to App")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                }
            }
        }
        .padding()
    }
}

// AuthenticationService.swift included in LoginView
class AuthenticationService: ObservableObject {
    @Published var user: FirebaseAuth.User?
    init() {
        self.user = Auth.auth().currentUser
    }
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let user = result?.user {
                self.user = user
                completion(true)
            } else {
                print("Login failed: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
            }
        }
    }
    func signOut() {
        try? Auth.auth().signOut()
        self.user = nil
    }
    func signUp(email: String, password: String, username: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let user = result?.user {
                self.user = user
                Firestore.firestore().collection("users").document(user.uid).setData([
                    "email": email,
                    "username": username,
                    "profilePictureURL": "",
                    "followerCount": 0,
                    "followingCount": 0
                ]) { error in
                    if let error = error {
                        print("Failed to save user data: \(error)")
                    }
                }
                completion(true)
            } else {
                print("Sign up failed: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
            }
        }
    }
}
