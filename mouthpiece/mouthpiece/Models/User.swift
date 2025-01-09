//
//  User.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/8/24.
//


import Foundation

struct User: Identifiable , Decodable{
    let id: String
    let username: String
    let email: String
    let profilePictureURL: String
    let bio: String
    let badges: [String] // Optional badges like "Top Player"
    let followersCount: Int
    let followingCount: Int
    let postsCount: Int
    
    init(id: String, username: String, email: String, profilePictureURL: String = "", bio: String = "", badges: [String] = [], followersCount: Int = 0, followingCount: Int = 0, postsCount: Int = 0) {
        self.id = id
        self.username = username
        self.email = email
        self.profilePictureURL = profilePictureURL
        self.bio = bio
        self.badges = badges
        self.followersCount = followersCount
        self.followingCount = followingCount
        self.postsCount = postsCount
    }
}
