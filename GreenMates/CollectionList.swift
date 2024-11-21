import SwiftUICore
import SwiftUI


struct CollectionList: View {
    @State private var items: [CollectionItemModel] = []
    @State private var isLoading = true
    @State private var expandedItemID: UUID?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Eventos Activos")
                .font(.title)
                .padding(.bottom)

            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ForEach(items) { item in
                    CollectionItemView(
                        item: item,
                        isExpanded: expandedItemID == item.id,
                        onTap: {
                            expandedItemID = expandedItemID == item.id ? nil : item.id
                        }
                    )
                }
            }
        }
        .padding()
        .onAppear {
            fetchData()
        }
    }

    private func fetchData() {
        isLoading = true
        let dispatchGroup = DispatchGroup()

        var fetchedTalleres: [Tallers] = []
        var fetchedRecolectas: [Recolectas] = []

        dispatchGroup.enter()
        ApiService.shared.getAllCourses { result in
            switch result {
            case .success(let talleres):
                fetchedTalleres = talleres
            case .failure(let error):
                print("Error fetching talleres: \(error)")
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        ApiService.shared.getAllRecolectas { result in
            switch result {
            case .success(let recolectas):
                fetchedRecolectas = recolectas
            case .failure(let error):
                print("Error fetching recolectas: \(error)")
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            self.items = fetchedTalleres.map { CollectionItemModel(from: $0) } +
                         fetchedRecolectas.map { CollectionItemModel(from: $0) }
            self.isLoading = false
        }
    }
}

struct CollectionItemView: View {
    var item: CollectionItemModel
    var isExpanded: Bool
    var onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(item.title)
                        .fontWeight(.bold)
                    Text(item.address)
                        .font(.caption)
                }
                Spacer()
                ZStack {
                    Circle()
                        .stroke(lineWidth: 6)
                        .opacity(0.3)
                        .foregroundColor(Color.green)
                    Circle()
                        .trim(from: 0.0, to: CGFloat(item.percentage))
                        .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color.green)
                        .rotationEffect(Angle(degrees: -90))
                    Text("\(item.percentage)%")
                        .bold()
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGray6)))
            .onTapGesture {
                onTap()
            }

            if isExpanded {
                Divider().padding(.vertical, 4)
                VStack(alignment: .leading, spacing: 8) {
                    if let pillar = item.pillar {
                        Text("Pillar: \(pillar)")
                            .font(.subheadline)
                    }
                    Text("Start: \(item.startTime.formattedDate())")
                        .font(.subheadline)
                    Text("End: \(item.endTime.formattedDate())")
                        .font(.subheadline)
                    Text("Collaborator: \(item.collaboratorFBID)")
                        .font(.subheadline)
                    Text("Limit: \(item.limit)")
                        .font(.subheadline)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGray5)))
            }
        }
        .animation(.easeInOut, value: isExpanded)
    }
}

struct CollectionItemModel: Identifiable {
    let id = UUID()
    let title: String
    let address: String
    let percentage: Int
    let startTime: Date
    let endTime: Date
    let collaboratorFBID: String
    var limit: Int
    let pillar: String?

    init(from taller: Tallers) {
        self.title = taller.Title
        self.address = "\(taller.Longitude), \(taller.Latitude)"
        self.percentage = taller.AssistantArray.count * 100 / (taller.Limit > 0 ? taller.Limit : 1)
        self.startTime = taller.StartTime
        self.endTime = taller.EndTime
        self.collaboratorFBID = taller.CollaboratorFBID
        self.limit = taller.Limit
        self.pillar = taller.Pillar
    }

    init(from recolecta: Recolectas) {
        self.title = "Recolecta"
        self.address = "\(recolecta.Longitude), \(recolecta.Latitude)"
        self.percentage = recolecta.DonationArray.count * 100 / (recolecta.Limit > 0 ? recolecta.Limit : 1)
        self.startTime = recolecta.StartTime
        self.endTime = recolecta.EndTime
        self.collaboratorFBID = recolecta.CollaboratorFBID
        self.limit = recolecta.Limit
        self.pillar = nil
    }
}


struct CollectionItem: View {
    var taller: Tallers
    var isExpanded: Bool
    var onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Main row
            HStack {
                VStack(alignment: .leading) {
                    Text(taller.Title)
                        .fontWeight(.bold)
                    Text("\(taller.Longitude), \(taller.Latitude)")
                        .font(.caption)
                }
                Spacer()
                ProgressView(value: Float(50) / 100)
                    .frame(width: 50, height: 50)
            }
            .onTapGesture {
                onTap()
            }

            if isExpanded {
                Divider()
                    .padding(.vertical, 4)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Pilar: \(taller.Pillar)")
                        .font(.subheadline)
                    Text("Inicio: \(taller.StartTime.formattedDate())")
                        .font(.subheadline)
                    Text("Fin: \(taller.EndTime.formattedDate())")
                        .font(.subheadline)
                    Text("Colaborador: \(taller.CollaboratorFBID)")
                        .font(.subheadline)
                    Text("Límite: \(taller.Limit)")
                        .font(.subheadline)
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGray6)))
        .animation(.easeInOut, value: isExpanded)
    }
}

extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}


