import SwiftUI
import AVKit
import FirebaseFirestore
import FirebaseAuth

struct PostCellView: View {
    let post: Post
    let onUserTap: (String) -> Void
    let commentAction: (String) -> Void
    @State private var likesCount: Int
    @State private var userHasLiked = false

    private let db = Firestore.firestore()
    private let currentUserId = Auth.auth().currentUser?.uid

    init(post: Post, onUserTap: @escaping (String) -> Void, commentAction: @escaping (String) -> Void) {
        self.post = post
        self.onUserTap = onUserTap
        self.commentAction = commentAction
        _likesCount = State(initialValue: post.likesCount)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let avatarURL = post.avatarURL, let url = URL(string: avatarURL.replacingOccurrences(of: "http://", with: "https://")) {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Circle().fill(Color.gray.opacity(0.5))
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .onTapGesture {
                        onUserTap(post.userId)
                    }
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 40, height: 40)
                        .onTapGesture {
                            onUserTap(post.userId)
                        }
                }

                VStack(alignment: .leading) {
                    Text(post.username ?? "Unknown")
                        .font(.headline)
                        .onTapGesture {
                            onUserTap(post.userId)
                        }
                    Text(post.playstyleTag ?? "Loading...")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()
            }
            .padding(.bottom, 8)

            if post.isVideo {
                if let videoURL = URL(string: post.contentImageURL.replacingOccurrences(of: "http://", with: "https://")) {
                    VideoPlayerView(videoURL: videoURL)
                        .frame(height: 300)
                        .cornerRadius(10)
                } else {
                    Text("Error loading video")
                        .foregroundColor(.red)
                }
            } else if let imageURL = URL(string: post.contentImageURL.replacingOccurrences(of: "http://", with: "https://")) {
                AsyncImage(url: imageURL) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Rectangle().fill(Color.gray.opacity(0.5))
                }
                .cornerRadius(10)
                .padding(.bottom, 8)
            }

            Text(post.caption)
                .font(.body)
                .padding(.bottom, 8)

            HStack(spacing: 20) {
                Button(action: {
                    likePost()
                }) {
                    HStack {
                        Image(systemName: userHasLiked ? "heart.fill" : "heart")
                            .foregroundColor(userHasLiked ? .red : .gray)
                        Text("\(likesCount)")
                    }
                }

                Button(action: {
                    commentAction(post.id)
                }) {
                    HStack {
                        Image(systemName: "bubble.right")
                        Text("Comment")
                    }
                }

                Button(action: {
                    sharePost(post.id)
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
                    }
                }
            }
            .foregroundColor(.blue)
            .padding(.top, 8)
        }
        .padding()
        .onAppear {
            checkIfUserHasLiked()
        }
    }

    private func likePost() {
        guard let currentUserId = currentUserId else { return }
        let postRef = db.collection("posts").document(post.id)

        if userHasLiked {
            postRef.updateData(["likesCount": FieldValue.increment(Int64(-1))]) { error in
                if error == nil {
                    likesCount -= 1
                    userHasLiked = false
                }
            }
            postRef.collection("likes").document(currentUserId).delete()
        } else {
            postRef.updateData(["likesCount": FieldValue.increment(Int64(1))]) { error in
                if error == nil {
                    likesCount += 1
                    userHasLiked = true
                }
            }
            postRef.collection("likes").document(currentUserId).setData([:])
        }
    }

    private func checkIfUserHasLiked() {
        guard let currentUserId = currentUserId else { return }
        let postRef = db.collection("posts").document(post.id)

        postRef.collection("likes").document(currentUserId).getDocument { document, _ in
            userHasLiked = document?.exists ?? false
        }
    }

    private func sharePost(_ postId: String) {
        print("Share post: \(postId)")
    }
}
