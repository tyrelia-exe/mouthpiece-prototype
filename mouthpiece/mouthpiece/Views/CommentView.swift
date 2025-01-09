import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct CommentView: View {
    let postId: String
    @State private var comments: [Comment] = []
    @State private var newComment = ""
    @State private var isLoading = true

    private let db = Firestore.firestore()
    private let currentUserId = Auth.auth().currentUser?.uid

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading comments...")
            } else {
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(comments) { comment in
                            HStack(alignment: .top, spacing: 15) {
                                // User Avatar
                                if let url = URL(string: comment.avatarURL) {
                                    AsyncImage(url: url) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        Circle().fill(Color.gray.opacity(0.5))
                                    }
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                } else {
                                    Circle()
                                        .fill(Color.gray.opacity(0.5))
                                        .frame(width: 40, height: 40)
                                }

                                // Comment Content
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(comment.username)
                                        .font(.headline)
                                    Text(comment.commentText)
                                        .font(.body)
                                    Text(comment.timestamp, style: .time)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }

                // New Comment Input
                HStack {
                    TextField("Write a comment...", text: $newComment)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button(action: addComment) {
                        Image(systemName: "paperplane.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    .disabled(newComment.isEmpty)
                    .padding(.trailing)
                }
                .padding(.vertical)
            }
        }
        .onAppear(perform: fetchComments)
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func fetchComments() {
        db.collection("posts").document(postId).collection("comments")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching comments: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No comments found")
                    return
                }

                DispatchQueue.main.async {
                    comments = documents.compactMap { doc in
                        let data = doc.data()
                        return Comment(
                            id: doc.documentID,
                            userId: data["userId"] as? String ?? "",
                            username: data["username"] as? String ?? "Unknown",
                            avatarURL: data["avatarURL"] as? String ?? "",
                            commentText: data["commentText"] as? String ?? "",
                            timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                        )
                    }
                    isLoading = false
                }
            }
    }

    private func addComment() {
        guard let currentUserId = currentUserId else { return }

        db.collection("users").document(currentUserId).getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                print("Error fetching user data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let username = data["username"] as? String ?? "Unknown"
            let avatarURL = data["profilePictureURL"] as? String ?? ""

            let commentData: [String: Any] = [
                "userId": currentUserId,
                "username": username,
                "avatarURL": avatarURL,
                "commentText": newComment,
                "timestamp": FieldValue.serverTimestamp()
            ]

            db.collection("posts").document(postId).collection("comments").addDocument(data: commentData) { error in
                if let error = error {
                    print("Error adding comment: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        newComment = ""
                    }
                }
            }
        }
    }
}
