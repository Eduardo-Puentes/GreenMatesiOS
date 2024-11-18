struct CollectionList: View {
    @State private var talleres: [Taller] = []
    @State private var isLoading = true

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                Text("Active Courses")
                    .font(.title)
                    .padding(.bottom)

                ForEach(talleres) { taller in
                    CollectionItem(
                        title: taller.title,
                        address: "\(taller.longitude), \(taller.latitude)",
                        percentage: calculateCompletionPercentage(taller: taller),
                        isOngoing: isCourseOngoing(start: taller.startTime, end: taller.endTime)
                    )
                }
            }
        }
        .onAppear {
            fetchTalleres()
        }
    }

    func fetchTalleres() {
        // Simulate fetching talleres
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.talleres = mockTalleres // Replace with API call
            self.isLoading = false
        }
    }

    func calculateCompletionPercentage(taller: Taller) -> Int {
        return 50 // Replace with logic
    }

    func isCourseOngoing(start: Date, end: Date) -> Bool {
        let now = Date()
        return now >= start && now <= end
    }
}

struct CollectionItem: View {
    var title: String
    var address: String
    var percentage: Int
    var isOngoing: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .fontWeight(.bold)
                Text(address)
                    .font(.caption)
            }
            Spacer()
            ProgressView(value: Float(percentage) / 100)
                .progressViewStyle(CircularProgressViewStyle(tint: isOngoing ? .green : .gray))
                .frame(width: 50, height: 50)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGray6)))
    }
}

// Mock data for testing
struct Taller: Identifiable {
    let id = UUID()
    let title: String
    let longitude: Double
    let latitude: Double
    let startTime: Date
    let endTime: Date
}

let mockTalleres = [
    Taller(title: "Recycling Challenge", longitude: -99.1332, latitude: 19.4326, startTime: Date(), endTime: Date().addingTimeInterval(3600))
]
