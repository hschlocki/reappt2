import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            CameraView()
                .tabItem {
                    Label("New Post", systemImage: "square.and.pencil")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
            MessagesView()
                .tabItem {
                    Label("Messages", systemImage: "message")
                }
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "magnifyingglass")
                }
        }
    }
}
