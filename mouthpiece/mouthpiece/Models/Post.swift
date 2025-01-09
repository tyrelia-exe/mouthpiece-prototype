//
//  Post.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/8/24.
//

import Foundation
struct Post: Identifiable {
    let id: String
    let userId: String
    var username: String? // Nullable for delayed fetch
    var avatarURL: String? // Nullable for delayed fetch
    var playstyleTag: String? // Nullable for delayed fetch
    var isVideo: Bool
    let contentImageURL: String
    let caption: String
    let likesCount: Int
    let commentsCount: Int
    let timestamp: Date
}


