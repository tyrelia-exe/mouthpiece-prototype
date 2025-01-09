//
//  Court.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/10/24.
//


import Foundation
import CoreLocation

struct Court: Identifiable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let rating: Double
    let usersActive: Int

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
