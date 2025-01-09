//
//  Message.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/9/24.
//

import Foundation

import Foundation

struct Message: Identifiable {
    var id: String
    var senderId: String
    var recipientId: String
    var text: String
    var timestamp: Date
}

