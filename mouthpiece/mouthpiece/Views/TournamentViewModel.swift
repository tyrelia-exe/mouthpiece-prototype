//
//  TournamentViewModel.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/8/24.
//


import Foundation
import FirebaseFirestore

class TournamentViewModel: ObservableObject {
    @Published var tournaments: [Tournament] = []

    private let db = Firestore.firestore()

    func fetchTournaments() {
        db.collection("tournaments").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching tournaments: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self.tournaments = documents.compactMap { doc -> Tournament? in
                let data = doc.data()
                guard
                    let name = data["name"] as? String,
                    let startDate = (data["startDate"] as? Timestamp)?.dateValue(),
                    let endDate = (data["endDate"] as? Timestamp)?.dateValue()
                else {
                    return nil
                }

                return Tournament(
                    id: doc.documentID,
                    name: name,
                    description: data["description"] as? String ?? "",
                    startDate: startDate,
                    endDate: endDate,
                    participants: data["participants"] as? [String] ?? [],
                    location: data["location"] as? String ?? ""
                )
            }
        }
    }
}
