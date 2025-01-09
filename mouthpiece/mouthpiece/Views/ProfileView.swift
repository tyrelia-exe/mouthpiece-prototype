import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProfileView: View {
    let profileUserId: String

    @State private var userData: [String: Any] = [:]
    @State private var userPosts: [Post] = []
    @State private var userShorts: [Post] = []
    @State private var isLoading = true
    @State private var isFollowing = false
    @State private var isEditProfileViewPresented = false
    @State private var isChatViewPresented = false
    @State private var isShowingSignOutConfirmation = false

    private let db = Firestore.firestore()
    private let currentUserId = Auth.auth().currentUser?.uid

    var isCurrentUser: Bool {
        profileUserId == currentUserId
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                if isLoading {
                    ProgressView("Loading...")
                } else {
                    // Profile Header
                    VStack(alignment: .center) {
                        HStack(alignment: .top, spacing: 20) {
                            // Profile Picture
                            if let profilePictureURL = userData["profilePictureURL"] as? String,
                               let url = URL(string: profilePictureURL.replacingOccurrences(of: "http://", with: "https://")) {
                                AsyncImage(url: url) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    Circle().fill(Color.gray.opacity(0.5))
                                }
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(width: 100, height: 100)
                            }

                            // Stats Section
                            VStack(alignment: .leading) {
                                HStack {
                                    ProfileStat(label: "\(userPosts.count)", description: "Posts")
                                    Divider().frame(height: 20).background(Color.black)
                                    ProfileStat(label: "\(userData["followersCount"] as? Int ?? 0)", description: "Followers")
                                    Divider().frame(height: 20).background(Color.black)
                                    ProfileStat(label: "\(userData["followingCount"] as? Int ?? 0)", description: "Following")
                                    Divider().frame(height: 20).background(Color.black)
                                    ProfileStat(label: "A", description: "MP Rank")
                                }
                            }
                        }
                        .padding(.horizontal)

                        Text(userData["username"] as? String ?? "@Unknown")
                            .font(.title2)
                            .bold()

                        VStack(spacing: 5) {
                            Text(userData["name"] as? String ?? "Name Not Available")
                                .font(.headline)
                            Text("\(userData["city"] as? String ?? ""), \(userData["state"] as? String ?? "")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        // Buttons
                        HStack(spacing: 15) {
                            if isCurrentUser {
                                Button(action: {
                                    isEditProfileViewPresented = true
                                }) {
                                    ProfileButton(label: "Edit Profile", icon: "pencil", backgroundColor: .blue, textColor: .white)
                                }
                                .sheet(isPresented: $isEditProfileViewPresented) {
                                    EditProfileView()
                                }

                                Button(action: {
                                    isShowingSignOutConfirmation = true
                                }) {
                                    ProfileButton(label: "Sign Out", icon: "arrow.uturn.backward", backgroundColor: .red, textColor: .white)
                                }
                                .alert(isPresented: $isShowingSignOutConfirmation) {
                                    Alert(
                                        title: Text("Sign Out"),
                                        message: Text("Are you sure you want to sign out?"),
                                        primaryButton: .destructive(Text("Sign Out")) {
                                            signOut()
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                            } else {
                                Button(action: {
                                    isChatViewPresented = true
                                }) {
                                    ProfileButton(label: "Chat", icon: "message", backgroundColor: .gray.opacity(0.2), textColor: .black)
                                }
                                .sheet(isPresented: $isChatViewPresented) {
                                    ChatView(recipientId: profileUserId, recipientName: userData["username"] as? String ?? "Unknown")
                                }

                                Button(action: followUser) {
                                    ProfileButton(
                                        label: isFollowing ? "Unfollow" : "Follow",
                                        icon: isFollowing ? "person.badge.minus" : "person.badge.plus",
                                        backgroundColor: isFollowing ? .red : .blue,
                                        textColor: .white
                                    )
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .top)

                    Divider().padding(.vertical)

                    // Posts Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Posts")
                            .font(.headline)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                            ForEach(userPosts) { post in
                                if let imageURL = URL(string: post.contentImageURL) {
                                    AsyncImage(url: imageURL) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        Rectangle().fill(Color.gray.opacity(0.5))
                                    }
                                    .frame(height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }
                    }
                    .padding(.horizontal)

                    // Shorts Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Shorts")
                            .font(.headline)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                            ForEach(userShorts) { short in
                                if let videoURL = URL(string: short.contentImageURL) {
                                    VideoPlayerView(videoURL: videoURL)
                                        .frame(height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            fetchProfileData()
            fetchUserContent()
        }
        .background(Color(.systemBackground))
    }

    private func fetchProfileData() {
        db.collection("users").document(profileUserId).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching profile data: \(error.localizedDescription)")
                return
            }

            guard let data = snapshot?.data() else {
                print("No profile data found")
                return
            }

            DispatchQueue.main.async {
                userData = data
                isLoading = false
            }

            if !isCurrentUser {
                guard let currentUserId = currentUserId else { return }
                db.collection("users").document(currentUserId).collection("following").document(profileUserId).getDocument { doc, _ in
                    DispatchQueue.main.async {
                        isFollowing = doc?.exists ?? false
                    }
                }
            }
        }
    }

    private func fetchUserContent() {
        db.collection("posts")
            .whereField("userId", isEqualTo: profileUserId)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching posts: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No posts found")
                    return
                }

                DispatchQueue.main.async {
                    userPosts = []
                    userShorts = []

                    for doc in documents {
                        let data = doc.data()
                        let isVideo = data["isVideo"] as? Bool ?? false
                        let post = Post(
                            id: doc.documentID,
                            userId: data["userId"] as? String ?? "",
                            username: data["username"] as? String ?? "",
                            avatarURL: data["profilePictureURL"] as? String ?? "",
                            playstyleTag: data["playstyleTag"] as? String ?? "",
                            isVideo: isVideo,
                            contentImageURL: data["mediaURL"] as? String ?? data["contentImageURL"] as? String ?? "",
                            caption: data["caption"] as? String ?? "",
                            likesCount: data["likesCount"] as? Int ?? 0,
                            commentsCount: data["commentsCount"] as? Int ?? 0,
                            timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                        )

                        if isVideo {
                            userShorts.append(post)
                        } else {
                            userPosts.append(post)
                        }
                    }
                }
            }
    }

    private func followUser() {
        guard let currentUserId = currentUserId else { return }

        let currentUserFollowingRef = db.collection("users").document(currentUserId).collection("following").document(profileUserId)
        let profileUserFollowersRef = db.collection("users").document(profileUserId).collection("followers").document(currentUserId)

        if isFollowing {
            currentUserFollowingRef.delete { error in
                if let error = error {
                    print("Error unfollowing user: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        isFollowing = false
                    }
                }
            }

            profileUserFollowersRef.delete { error in
                if let error = error {
                    print("Error removing follower: \(error.localizedDescription)")
                }
            }
        } else {
            currentUserFollowingRef.setData([:]) { error in
                if let error = error {
                    print("Error following user: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        isFollowing = true
                    }
                }
            }

            profileUserFollowersRef.setData([:]) { error in
                if let error = error {
                    print("Error adding follower: \(error.localizedDescription)")
                }
            }
        }
    }

    private func signOut() {
        do {
            try Auth.auth().signOut()
            // Navigate to the login screen
            // Ensure you have a navigation or app logic to handle the signed-out state
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.first?.rootViewController = UIHostingController(rootView: LoginView())
                windowScene.windows.first?.makeKeyAndVisible()
                
            }
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
