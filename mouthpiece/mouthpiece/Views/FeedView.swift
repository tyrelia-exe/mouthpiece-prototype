import SwiftUI
import FirebaseFirestore

struct FeedView: View {
    @State private var posts: [Post] = []
    @State private var isCreatePostPresented = false
    @State private var selectedUserId: String? = nil
    @State private var selectedPostId: String? = nil // State for navigating to comments
    private let db = Firestore.firestore()

    var body: some View {
        NavigationView {
            VStack {
                if posts.isEmpty {
                    Text("No posts yet! Follow some users to see their posts.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(posts) { post in
                                PostCellView(post: post) { userId in
                                    selectedUserId = userId
                                } commentAction: { postId in
                                    selectedPostId = postId
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .onAppear(perform: fetchAllPosts)
            .navigationBarTitle("Feed", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        isCreatePostPresented = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $isCreatePostPresented) {
                CreatePostView()
            }
            .background(
                Group {
                    NavigationLink(
                        destination: selectedUserId.map { ProfileView(profileUserId: $0) },
                        isActive: Binding(
                            get: { selectedUserId != nil },
                            set: { if !$0 { selectedUserId = nil } }
                        )
                    ) { EmptyView() }
                    .hidden()

                    NavigationLink(
                        destination: selectedPostId.map { CommentView(postId: $0) },
                        isActive: Binding(
                            get: { selectedPostId != nil },
                            set: { if !$0 { selectedPostId = nil } }
                        )
                    ) { EmptyView() }
                    .hidden()
                }
            )
        }
    }

    private func fetchAllPosts() {
        db.collection("posts")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("No posts found")
                    return
                }

                var fetchedPosts: [Post] = documents.compactMap { doc in
                    let data = doc.data()
                    let resolvedMediaURL = data["mediaURL"] as? String ?? data["contentImageURL"] as? String ?? ""

                    return Post(
                        id: doc.documentID,
                        userId: data["userId"] as? String ?? "",
                        username: nil,
                        avatarURL: nil,
                        playstyleTag: nil,
                        isVideo: data["isVideo"] as? Bool ?? false,
                        contentImageURL: resolvedMediaURL,
                        caption: data["caption"] as? String ?? "",
                        likesCount: data["likesCount"] as? Int ?? 0,
                        commentsCount: data["commentsCount"] as? Int ?? 0,
                        timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                    )
                }

                let group = DispatchGroup()
                for i in 0..<fetchedPosts.count {
                    group.enter()
                    let userId = fetchedPosts[i].userId
                    db.collection("users").document(userId).getDocument { userSnapshot, userError in
                        if let userData = userSnapshot?.data() {
                            fetchedPosts[i].username = userData["username"] as? String ?? "Unknown"
                            fetchedPosts[i].avatarURL = userData["profilePictureURL"] as? String ?? ""
                            fetchedPosts[i].playstyleTag = userData["playstyleTag"] as? String ?? ""
                        } else {
                            print("Error fetching user data for userId \(userId): \(userError?.localizedDescription ?? "Unknown error")")
                        }
                        group.leave()
                    }
                }

                group.notify(queue: .main) {
                    self.posts = fetchedPosts
                }
            }
    }
}
