//
//  MPAnnotation.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/10/24.
//


import MapKit

struct MPAnnotation: Identifiable, Equatable {
    let id = UUID() // Unique identifier for each annotation
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    
    static func == (lhs: MPAnnotation, rhs: MPAnnotation) -> Bool {
        return lhs.id == rhs.id
    }
}
