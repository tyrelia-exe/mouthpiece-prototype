import SwiftUI
import MapKit
import CoreLocation

struct MPMapView: View {
    @StateObject private var viewModel = MPMapViewModel()
    @State private var isZoomedToUserLocation = false
    @State private var selectedAnnotation: MPAnnotation? = nil
    @State private var selectedCourtDetails: CourtDetails? = nil
    @State private var currentRegion: MKCoordinateRegion = MKCoordinateRegion()

    var body: some View {
        ZStack {
            // MapView
            Map(coordinateRegion: $viewModel.region,
                showsUserLocation: true,
                annotationItems: viewModel.annotations) { annotation in
                MapAnnotation(coordinate: annotation.coordinate) {
                    BasketballMarker(annotation: annotation, isSelected: annotation == selectedAnnotation)
                        .onTapGesture {
                            markerTapped(annotation: annotation)
                        }
                }
            }
            .onAppear {
                viewModel.checkLocationAuthorization()
            }
            .onChange(of: viewModel.userLocation) { newLocation in
                if !isZoomedToUserLocation, let location = newLocation {
                    zoomToUserLocation(at: location)
                    isZoomedToUserLocation = true
                }
            }

            // Court Details Popout
            if let courtDetails = selectedCourtDetails {
                VStack {
                    Spacer()
                    CourtDetailsView(courtDetails: courtDetails) {
                        selectedCourtDetails = nil
                    }
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: selectedCourtDetails)
                }
            }

            // Floating Button to Search for Basketball Gyms
            VStack {
                Spacer()
                Button(action: {
                    if let userLocation = viewModel.userLocation {
                        viewModel.searchForGyms(at: userLocation)
                    }
                }) {
                    Text("Search for Basketball Gyms")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
    }

    private func markerTapped(annotation: MPAnnotation) {
        selectedAnnotation = annotation

        // Center the map on the selected marker with animation
        withAnimation(.easeInOut) {
            centerMapOnLocation(annotation.coordinate)
        }

        // Load details for the selected court
        selectedCourtDetails = CourtDetails(
            name: annotation.title ?? "Unknown Court",
            address: annotation.subtitle ?? "No address available",
            hours: "Open 24/7",
            rating: "4.5/5",
            users: 120,
            activeUsers: 20,
            images: ["image1_url", "image2_url", "image3_url"]
        )
    }

    private func zoomToUserLocation(at coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        withAnimation(.easeInOut) {
            viewModel.region = region
        }
    }

    private func centerMapOnLocation(_ coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 500, // Adjust zoom level
            longitudinalMeters: 500
        )
        viewModel.region = region
    }
}

struct BasketballMarker: View {
    let annotation: MPAnnotation
    let isSelected: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(isSelected ? Color.orange : Color.blue)
                .frame(width: isSelected ? 40 : 30, height: isSelected ? 40 : 30)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                        .scaleEffect(isSelected ? 1.2 : 1)
                        .animation(.spring(), value: isSelected)
                )
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
            Image(systemName: "basketball.fill")
                .foregroundColor(.white)
                .font(.system(size: isSelected ? 20 : 15))
                .scaleEffect(isSelected ? 1.2 : 1)
                .animation(.spring(), value: isSelected)
        }
        .hoverEffect(.lift)
    }
}

struct CourtDetailsView: View {
    let courtDetails: CourtDetails
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(courtDetails.name)
                    .font(.headline)
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }

            Text(courtDetails.address)
                .font(.subheadline)
                .foregroundColor(.gray)

            HStack {
                Text("Hours: \(courtDetails.hours)")
                Spacer()
                Text("Rating: \(courtDetails.rating)")
            }
            .font(.subheadline)

            HStack {
                Text("Users: \(courtDetails.users)")
                Spacer()
                Text("Active: \(courtDetails.activeUsers)")
            }
            .font(.subheadline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(courtDetails.images, id: \.self) { imageUrl in
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image.resizable()
                                 .scaledToFill()
                        } placeholder: {
                            Rectangle().fill(Color.gray.opacity(0.5))
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
    }
}


extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
