//
//  ComposeMessageView.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/9/24.
//


import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

struct ComposeMessageView: View {
    @State private var recipients: [User] = [] // Assume User is a model representing users.
    @State private var searchQuery = ""
    @State private var isChatViewPresented = false
    @State private var selectedRecipient: User?

    var body: some View {
        VStack {
            TextField("Search...", text: $searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            List(recipients) { recipient in
                Button(action: {
                    self.selectedRecipient = recipient
                    self.isChatViewPresented = true
                }) {
                    Text(recipient.username)
                }
            }

            NavigationLink(
                destination: ChatView(
                    recipientId: selectedRecipient?.id ?? "",
                    recipientName: selectedRecipient?.username ?? ""
                ),
                isActive: $isChatViewPresented
            ) {
                EmptyView()
            }
        }
        .onAppear(perform: fetchRecipients)
    }

    private func fetchRecipients() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        // Assuming there is a "following" subcollection under the user's document
        db.collection("users")
            .document(userId)
            .collection("following")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching recipients: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No documents found in following collection.")
                    return
                }
                
                // Safely map the following users to the `recipients` array
                self.recipients = documents.compactMap { doc -> User? in
                    let data = doc.data()
                    
                    // Safely unwrap each field to ensure a valid User object is created
                    guard let id = data["id"] as? String,
                          let username = data["username"] as? String,
                          let email = data["email"] as? String else {
                        print("Invalid data for user in following: \(data)")
                        return nil
                    }
                    return User(id: id, username: username, email: email)

                }
                
                print("Fetched recipients: \(self.recipients)")
            }
    }


}

 
