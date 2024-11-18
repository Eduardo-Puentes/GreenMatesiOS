import SwiftUI
import MapKit

struct HomeScreen: View {
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar()
                MapViewWithMarkers()
                    .frame(height: 250)
                CollectionList()
            }
            .padding()
        }
    }
}

struct SearchBar: View {
    var body: some View {
        TextField("Encuentra retos cerca de ti", text: .constant(""))
            .disabled(true)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
    }
}

struct MapViewWithMarkers: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: markers) { marker in
            MapAnnotation(coordinate: marker.coordinate) {
                VStack {
                    ProgressView(value: Float(marker.percentage) / 100)
                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                        .frame(width: 40, height: 40)
                    Text("\(marker.percentage)%")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
        }
    }

    let markers = [
        Marker(coordinate: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332), percentage: 50),
        Marker(coordinate: CLLocationCoordinate2D(latitude: 19.4426, longitude: -99.1332), percentage: 75),
        Marker(coordinate: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1432), percentage: 90)
    ]
}

struct Marker: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let percentage: Int
}
