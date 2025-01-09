//import SwiftUI
//
//struct HomeFeedView: View {
//    @StateObject private var postViewModel = PostViewModel()
//    @State private var isUserProfilePresented = false
//    @State private var selectedUserId: String?
//
//    var body: some View {
//        NavigationView {
//            List(postViewModel.posts) { post in
//                PostCellView(post: post)
//            }
//            .navigationTitle("Home Feed")
//            .onAppear {
//                postViewModel.fetchPosts()
//            }
//            .sheet(isPresented: $isUserProfilePresented) {
//                if let userId = selectedUserId {
//                    ProfileView() // Navigate to the selected user's profile
//                }
//            }
//        }
//    }
//}
