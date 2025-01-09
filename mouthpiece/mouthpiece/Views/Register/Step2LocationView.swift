import SwiftUI
import MapKit

// Custom wrapper for MKMapItem to conform to Identifiable
struct IdentifiableLocation: Identifiable {
    let id = UUID()
    let mapItem: MKMapItem
}

struct Step2LocationView: View {
    @State private var searchQuery = ""
    @State private var selectedLocation: IdentifiableLocation? = nil
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default to SF
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    var onNext: (String, String, CLLocationCoordinate2D) -> Void // Pass city, state, and coordinates

    var body: some View {
        VStack(spacing: 20) {
            Text("Search for your location")
                .foregroundColor(.white)
                .font(.title2)
                .bold()

            TextField("Search for your location", text: $searchQuery)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.white)
                .onChange(of: searchQuery) { newValue in
                    searchForLocation(query: newValue)
                }

            Map(coordinateRegion: $region, annotationItems: selectedLocation.map { [$0] } ?? []) { location in
                MapPin(coordinate: location.mapItem.placemark.coordinate, tint: .blue)
            }
            .frame(height: 300)
            .cornerRadius(10)

            Button(action: {
                if let selectedLocation = selectedLocation {
                    let placemark = selectedLocation.mapItem.placemark
                    let city = placemark.locality ?? "Unknown City"
                    let state = placemark.administrativeArea ?? "Unknown State"
                    let coordinates = placemark.coordinate
                    onNext(city, state, coordinates) // Pass the extracted data
                }
            }) {
                Text("Confirm Location")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .padding()
    }

    // Helper function to search for locations
    private func searchForLocation(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response, error == nil else { return }
            if let mapItem = response.mapItems.first {
                self.selectedLocation = IdentifiableLocation(mapItem: mapItem)
                self.region = MKCoordinateRegion(
                    center: mapItem.placemark.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            }
        }
    }
}
