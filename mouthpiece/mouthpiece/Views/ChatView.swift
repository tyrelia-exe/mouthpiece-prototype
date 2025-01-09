import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ChatView: View {
    let recipientId: String
    let recipientName: String

    @State private var messages: [Message] = []
    @State private var newMessage = ""

    private let db = Firestore.firestore()
    private let userId = Auth.auth().currentUser?.uid

    var body: some View {
        VStack {
            // Header
            HStack {
                Text(recipientName)
                    .font(.headline)
                    .padding()
                Spacer()
            }
            .background(Color.blue.opacity(0.1))

            // Messages List with Empty State
            ScrollView {
                if messages.isEmpty {
                    // Empty state
                    VStack {
                        Text("No messages yet. Start the conversation!")
                            .foregroundColor(.gray)
                            .padding()
                    }
                } else {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(messages) { message in
                            ChatBubble(message: message.text, isCurrentUser: message.senderId == userId)
                        }
                    }
                    .padding()
                }
            }

            // New Message Input
            HStack {
                TextField("Type a message...", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading)

                Button("Send") {
                    sendMessage()
                }
                .padding(.trailing)
                .disabled(newMessage.isEmpty)
            }
            .padding()
        }
        .onAppear(perform: fetchMessages)
    }

    // Fetch messages for the current conversation
    private func fetchMessages() {
        guard let userId = userId else { return }

        db.collection("messages")
            .whereField("participants", arrayContains: userId)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No messages found")
                    return
                }

                self.messages = documents.compactMap { document -> Message? in
                    let data = document.data()
                    guard let senderId = data["senderId"] as? String,
                          let recipientId = data["recipientId"] as? String,
                          let text = data["text"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp else {
                        return nil
                    }

                    // Ensure messages belong to this specific chat
                    if (senderId == userId && recipientId == self.recipientId) ||
                        (senderId == self.recipientId && recipientId == userId) {
                        return Message(id: document.documentID,
                                       senderId: senderId,
                                       recipientId: recipientId,
                                       text: text,
                                       timestamp: timestamp.dateValue())
                    }
                    return nil
                }.sorted(by: { $0.timestamp < $1.timestamp })
            }
    }

    // Send a new message
    private func sendMessage() {
        guard let userId = userId, !newMessage.isEmpty else { return }

        let message = Message(
            id: UUID().uuidString,
            senderId: userId,
            recipientId: recipientId,
            text: newMessage,
            timestamp: Date()
        )

        do {
            try db.collection("messages").document(message.id).setData([
                "senderId": message.senderId,
                "recipientId": message.recipientId,
                "text": message.text,
                "timestamp": message.timestamp,
                "participants": [userId, recipientId]
            ])
            newMessage = ""
        } catch {
            print("Error sending message: \(error.localizedDescription)")
        }
    }
}

