////
////  CourtParticipantsView.swift
////  mouthpiece
////
////  Created by Jennifer Biggs on 12/10/24.
////
//
//
//import SwiftUI
//import FirebaseFirestore
//import FirebaseAuth
//
//struct CourtParticipantsView: View {
//    let courtName: String
//    @State private var participants: [Participant] = []
//    @State private var isLoading = true
//    private let db = Firestore.firestore()
//    private let currentUserId = Auth.auth().currentUser?.uid
//
//    var body: some View {
//        VStack {
//            // Header
//            HStack {
//                Text("MP Participants")
//                    .font(.headline)
//                    .padding()
//                Spacer()
//                Button(action: {
//                    // Close functionality
//                }) {
//                    Image(systemName: "xmark.circle.fill")
//                        .font(.title2)
//                        .foregroundColor(.gray)
//                }
//                .padding()
//            }
//
//            // Participants List
//            if isLoading {
//                ProgressView("Loading participants...")
//            } else {
//                ScrollView {
//                    VStack(spacing: 10) {
//                        ForEach(participants) { participant in
//                            ParticipantRow(participant: participant)
//                        }
//                    }
//                }
//            }
//
//            // Mark as Present Button
//            if let currentUserId = currentUserId, !participants.contains(where: { $0.id == currentUserId }) {
//                Button(action: markUserAsPresent) {
//                    Text("I'm Here")
//                        .font(.headline)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//                .padding()
//            }
//        }
//        .onAppear {
//            fetchParticipants()
//        }
//        .background(Color.white)
//        .cornerRadius(15)
//        .shadow(radius: 5)
//        .padding()
//    }
//
//    private func fetchParticipants() {
//        db.collection("courts").document(courtName).collection("participants").getDocuments { snapshot, error in
//            if let error = error {
//                print("Error fetching participants: \(error.localizedDescription)")
//                return
//            }
//
//            guard let documents = snapshot?.documents else {
//                print("No participants found")
//                return
//            }
//
//            DispatchQueue.main.async {
//                participants = documents.compactMap { doc -> Participant? in
//                    let data = doc.data()
//                    return Participant(
//                        id: doc.documentID,
//                        username: data["username"] as? String ?? "Unknown",
//                        rank: data["rank"] as? String ?? "Unranked",
//                        team: data["team"] as? String ?? "No Team",
//                        status: data["status"] as? String ?? "Active",
//                        profilePictureURL: data["profilePictureURL"] as? String ?? ""
//                    )
//                }
//                isLoading = false
//            }
//        }
//    }
//
//    private func markUserAsPresent() {
//        guard let currentUserId = currentUserId else { return }
//
//        db.collection("users").document(currentUserId).getDocument { snapshot, error in
//            if let error = error {
//                print("Error fetching user data: \(error.localizedDescription)")
//                return
//            }
//
//            guard let userData = snapshot?.data() else { return }
//
//            let userInfo: [String: Any] = [
//                "username": userData["username"] as? String ?? "Unknown",
//                "rank": userData["rank"] as? String ?? "Unranked",
//                "team": userData["team"] as? String ?? "No Team",
//                "status": "Here",
//                "profilePictureURL": userData["profilePictureURL"] as? String ?? ""
//            ]
//
//            db.collection("courts").document(courtName).collection("participants").document(currentUserId).setData(userInfo) { error in
//                if let error = error {
//                    print("Error marking user as present: \(error.localizedDescription)")
//                } else {
//                    print("User marked as present")
//                    fetchParticipants() // Refresh participants list
//                }
//            }
//        }
//    }
//}
//
//// Participant Model
//struct Participant: Identifiable {
//    let id: String
//    let username: String
//    let rank: String
//    let team: String
//    let status: String
//    let profilePictureURL: String
//}
//
//// Participant Row View
//struct ParticipantRow: View {
//    let participant: Participant
//
//    var body: some View {
//        HStack(spacing: 10) {
//            if let url = URL(string: participant.profilePictureURL) {
//                AsyncImage(url: url) { image in
//                    image.resizable().scaledToFill()
//                } placeholder: {
//                    Circle().fill(Color.gray.opacity(0.5))
//                }
//                .frame(width: 40, height: 40)
//                .clipShape(Circle())
//            } else {
//                Circle()
//                    .fill(Color.gray.opacity(0.5))
//                    .frame(width: 40, height: 40)
//            }
//
//            VStack(alignment: .leading) {
//                Text(participant.username)
//                    .font(.headline)
//                Text(participant.rank)
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//
//            Spacer()
//
//            Text(participant.team)
//                .font(.subheadline)
//                .foregroundColor(.blue)
//
//            Image(systemName: participant.status == "Here" ? "checkmark.circle.fill" : "clock.fill")
//                .foregroundColor(participant.status == "Here" ? .green : .orange)
//        }
//        .padding(.vertical, 5)
//    }
//}
