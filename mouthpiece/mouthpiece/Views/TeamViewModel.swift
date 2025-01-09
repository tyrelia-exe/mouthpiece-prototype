//
//  TeamViewModel.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/8/24.
//


import Foundation
import FirebaseFirestore

class TeamViewModel: ObservableObject {
    @Published var teams: [Team] = []

    private let db = Firestore.firestore()

    func fetchTeams() {
        db.collection("teams").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching teams: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self.teams = documents.compactMap { doc -> Team? in
                let data = doc.data()
                return Team(
                    id: doc.documentID,
                    name: data["name"] as? String ?? "",
                    members: data["members"] as? [String] ?? [],
                    logoURL: data["logoURL"] as? String ?? "",
                    description: data["description"] as? String ?? ""
                )
            }
        }
    }
}
