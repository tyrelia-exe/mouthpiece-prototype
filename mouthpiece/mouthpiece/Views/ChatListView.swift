//
//  ChatListView.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/9/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ChatListView: View {
    @State private var chats: [Chat] = []
    private let db = Firestore.firestore()
    private let userId = Auth.auth().currentUser?.uid

    var body: some View {
        NavigationView {
            List(chats) { chat in
                NavigationLink(destination: ChatView(recipientId: chat.recipientId, recipientName: chat.recipientName)) {
                    HStack {
                        Text(chat.recipientName)
                            .font(.headline)
                        Spacer()
                        Text(chat.lastMessage)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .onAppear(perform: fetchChats)
            .navigationTitle("Chats")
        }
    }

    private func fetchChats() {
        guard let userId = userId else { return }
        db.collection("chats")
            .whereField("participants", arrayContains: userId)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                self.chats = documents.compactMap { try? $0.data(as: Chat.self) }
            }
    }
}
