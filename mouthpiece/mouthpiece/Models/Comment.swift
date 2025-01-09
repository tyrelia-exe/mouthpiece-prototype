//
//  Comment.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/10/24.
//

import Foundation


struct Comment: Identifiable {
    let id: String
    let userId: String
    let username: String
    let avatarURL: String
    let commentText: String
    let timestamp: Date
}
