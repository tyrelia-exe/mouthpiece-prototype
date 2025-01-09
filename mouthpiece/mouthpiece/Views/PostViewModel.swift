//import Foundation
//import FirebaseFirestore
//
//class PostViewModel: ObservableObject {
//    @Published var posts: [Post] = []
//
//    private let db = Firestore.firestore()
//
//    func fetchPosts() {
//        db.collection("posts")
//            .order(by: "timestamp", descending: true)
//            .addSnapshotListener { snapshot, error in
//                guard let documents = snapshot?.documents, error == nil else {
//                    print("Error fetching posts: \(error?.localizedDescription ?? "Unknown error")")
//                    return
//                }
//
//                self.posts = documents.compactMap { doc -> Post? in
//                    let data = doc.data()
//                    return Post(
//                        id: doc.documentID,
//                        userId: data["userId"] as? String ?? "",
//                        username: data["username"] as? String ?? "",
//                        avatarURL: data["avatarURL"] as? String ?? "",
//                        playstyleTag: data["playstyleTag"] as? String ?? "",
//                        contentImageURL: data["contentImageURL"] as? String ?? "",
//                        caption: data["caption"] as? String ?? "",
//                        likesCount: data["likesCount"] as? Int ?? 0,
//                        commentsCount: data["commentsCount"] as? Int ?? 0,
//                        timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
//                    )
//                }
//            }
//    }
//}
