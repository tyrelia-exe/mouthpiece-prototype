//
//  Chat.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/9/24.
//


import Foundation
import FirebaseFirestore

struct Chat: Identifiable, Codable {
    let id: String
    let participants: [String] // User IDs
    let lastMessage: String
    let lastMessageTimestamp: Date
    let recipientId: String
    let recipientName: String
}
