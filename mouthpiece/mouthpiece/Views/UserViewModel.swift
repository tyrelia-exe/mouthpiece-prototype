//
//  UserViewModel.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/8/24.
//


import Foundation
import FirebaseFirestore

class UserViewModel: ObservableObject {
    @Published var user: User?

    private let db = Firestore.firestore()

    func fetchUser(byId userId: String) {
        db.collection("users").document(userId).getDocument { document, error in
            guard let document = document, document.exists, let data = document.data() else {
                print("Error fetching user: \(error?.localizedDescription ?? "User not found")")
                return
            }

            self.user = User(
                id: document.documentID,
                username: data["username"] as? String ?? "",
                email: data["email"] as? String ?? "",
                profilePictureURL: data["profilePictureURL"] as? String ?? "",
                bio: data["bio"] as? String ?? "",
                badges: data["badges"] as? [String] ?? [],
                followersCount: data["followersCount"] as? Int ?? 0,
                followingCount: data["followingCount"] as? Int ?? 0,
                postsCount: data["postsCount"] as? Int ?? 0
            )
        }
    }
}
