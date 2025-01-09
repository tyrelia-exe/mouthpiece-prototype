//
//  MPMapViewModel.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/10/24.
//


import SwiftUI
import MapKit
import CoreLocation

final class MPMapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @Published var userLocation: CLLocationCoordinate2D? = nil
    @Published var annotations: [MPAnnotation] = []

    private let locationManager = CLLocationManager()

    func checkLocationAuthorization() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            DispatchQueue.main.async {
                self.userLocation = location.coordinate
            }
        }
    }

    func zoomToUserLocation(at coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    }

    func searchForGyms(at coordinate: CLLocationCoordinate2D) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "basketball gym"
        request.region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )

        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let response = response, error == nil else {
                print("Error searching for gyms: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            DispatchQueue.main.async {
                self?.annotations = response.mapItems.compactMap { item in
                    guard let name = item.name else { return nil }
                    return MPAnnotation(
                        coordinate: item.placemark.coordinate,
                        title: name,
                        subtitle: item.placemark.title ?? "No details available"
                    )
                }
            }
        }
    }
}
