import SwiftUI
import MapKit

import SwiftUI
import MapKit

struct HomeScreen: View {
    @State private var talleres: [Tallers] = []
    @State private var recolectas: [Recolectas] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(searchText: $searchText)

                if isLoading {
                    ProgressView("Loading...")
                } else if let error = errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else {
                    MapViewWithMarkers(talleres: talleres, recolectas: recolectas)
                        .frame(height: 250)
                    CollectionList(searchText: searchText)
                }
            }
            .padding()
            .onAppear {
                fetchData()
            }
        }
    }

    func fetchData() {
        isLoading = true
        errorMessage = nil

        let group = DispatchGroup()

        group.enter()
        ApiService.shared.getAllCourses { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedTalleres):
                    self.talleres = fetchedTalleres
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                group.leave()
            }
        }

        group.enter()
        ApiService.shared.getAllRecolectas { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedRecolectas):
                    self.recolectas = fetchedRecolectas
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.isLoading = false
        }
    }
}

struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        TextField("Encuentra retos cerca de ti", text: $searchText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
    }
}

struct MapViewWithMarkers: View {
    let talleres: [Tallers]
    let recolectas: [Recolectas]

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.0413, longitude: -98.2062),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    var body: some View {
        let combinedItems = talleres.map { MapItem(type: .taller, item: $0) } +
                            recolectas.map { MapItem(type: .recolecta, item: $0) }

        Map(coordinateRegion: $region, annotationItems: combinedItems) { mapItem in
            MapAnnotation(coordinate: mapItem.coordinate) {
                VStack {
                    ProgressCircle(progress: CGFloat(mapItem.assistantCount) / CGFloat(max(mapItem.limit, 1)))
                    Text(mapItem.title)
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
        }
    }

    struct MapItem: Identifiable {
        let id = UUID()
        let type: AnnotationType
        let item: Any

        var coordinate: CLLocationCoordinate2D {
            switch type {
            case .taller:
                let taller = item as! Tallers
                return CLLocationCoordinate2D(latitude: taller.Latitude, longitude: taller.Longitude)
            case .recolecta:
                let recolecta = item as! Recolectas
                return CLLocationCoordinate2D(latitude: recolecta.Latitude, longitude: recolecta.Longitude)
            }
        }

        var title: String {
            switch type {
            case .taller:
                return (item as! Tallers).Title
            case .recolecta:
                return "Recolecta"
            }
        }

        var assistantCount: Int {
            switch type {
            case .taller:
                return (item as! Tallers).AssistantArray.count
            case .recolecta:
                return (item as! Recolectas).DonationArray.count
            }
        }

        var limit: Int {
            switch type {
            case .taller:
                return (item as! Tallers).Limit
            case .recolecta:
                return (item as! Recolectas).Limit
            }
        }
    }

    enum AnnotationType {
        case taller
        case recolecta
    }
    
    struct ProgressCircle: View {
        let progress: CGFloat

        var body: some View {
            ZStack {
                Circle()
                    .stroke(lineWidth: 6)
                    .opacity(0.3)
                    .foregroundColor(Color.green)
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.green)
                    .rotationEffect(Angle(degrees: -90))
                Text("\(Int(progress * 100))%")
                    .bold()
            }
        }
    }
}


struct Marker: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let percentage: Int
}
