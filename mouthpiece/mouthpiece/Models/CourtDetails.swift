//
//  CourtDetails.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/10/24.
//
import Foundation
import CoreLocation

struct CourtDetails: Equatable {
    let name: String
    let address: String
    let hours: String
    let rating: String
    let users: Int
    let activeUsers: Int
    let images: [String]
    
    // Conformance to Equatable is automatically synthesized by Swift
    // for structs with all Equatable properties.
}
