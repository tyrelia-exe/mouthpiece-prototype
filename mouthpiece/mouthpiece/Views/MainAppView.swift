import SwiftUI
import FirebaseAuth

struct MainAppView: View {
    @State private var isCreatePostPresented = false

    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            MPMapView() // Add the MP Courts Map View here
                .tabItem {
                                Label("MP Courts", systemImage: "map.fill")
                            }


            Button(action: {
                isCreatePostPresented = true
            }) {
                VStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                    Text("Add A Post")
                }
            }
            .tabItem {
                Label("Add A Post", systemImage: "plus.circle.fill")
            }
            .sheet(isPresented: $isCreatePostPresented) {
                CreatePostView()
            }

            TeamsView()
                .tabItem {
                    Label("Teams", systemImage: "person.3.fill")
                }

            if let currentUserId = Auth.auth().currentUser?.uid {
                ProfileView(profileUserId: currentUserId)
                    .tabItem {
                        Label("Profile", systemImage: "person.circle.fill")
                    }
            }
        }
    }
}
