//
//  Team.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/8/24.
//


import Foundation

struct Team: Identifiable {
    let id: String
    let name: String
    let members: [String] // List of user IDs
    let logoURL: String
    let description: String
    
    init(id: String, name: String, members: [String] = [], logoURL: String = "", description: String = "") {
        self.id = id
        self.name = name
        self.members = members
        self.logoURL = logoURL
        self.description = description
    }
}
