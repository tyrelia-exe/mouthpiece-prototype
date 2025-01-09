//
//  Tournament.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/8/24.
//


import Foundation

struct Tournament: Identifiable {
    let id: String
    let name: String
    let description: String
    let startDate: Date
    let endDate: Date
    let participants: [String] // List of team IDs
    let location: String
    
    init(id: String, name: String, description: String = "", startDate: Date, endDate: Date, participants: [String] = [], location: String = "") {
        self.id = id
        self.name = name
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.participants = participants
        self.location = location
    }
}
