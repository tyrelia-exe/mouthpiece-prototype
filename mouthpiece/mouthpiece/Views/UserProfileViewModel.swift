//
//  UserProfileViewModel.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/9/24.
//


import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class UserProfileViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var location: String = ""
    @Published var profilePictureURL: String = ""

    private let db = Firestore.firestore()
    private let userId = Auth.auth().currentUser?.uid

    init() {
        fetchUserProfile()
    }

    func fetchUserProfile() {
        guard let userId = userId else { return }

        db.collection("users").document(userId).addSnapshotListener { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                print("Error fetching user profile: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            DispatchQueue.main.async {
                self.name = data["name"] as? String ?? ""
                self.location = data["location"] as? String ?? ""
                self.profilePictureURL = data["profilePictureURL"] as? String ?? ""
            }
        }
    }

    func updateUserProfile(name: String, location: String, profilePictureURL: String?) {
        guard let userId = userId else { return }

        var data: [String: Any] = [
            "name": name,
            "location": location
        ]
        if let profilePictureURL = profilePictureURL {
            data["profilePictureURL"] = profilePictureURL
        }

        db.collection("users").document(userId).updateData(data) { error in
            if let error = error {
                print("Error updating user profile: \(error.localizedDescription)")
            } else {
                print("User profile updated successfully!")
            }
        }
    }
}
