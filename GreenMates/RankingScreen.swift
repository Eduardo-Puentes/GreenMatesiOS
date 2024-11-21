import SwiftUI

import SwiftUI

struct RankingScreen: View {
    @State private var topTenUsers: [TopTenUser] = []
    @State private var isLoading: Bool = true
    @State private var errorMessage: String? = nil

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading Rankings...")
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    VStack {
                        Text("Ranking Semanal")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()

                        RankingList(users: topTenUsers)
                    }
                }
            }
            .onAppear {
                fetchTopTenUsers()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func fetchTopTenUsers() {
        ApiService.shared.fetchTopTenUsers { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self.topTenUsers = users
                    self.isLoading = false
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}


struct RankingList: View {
    let users: [TopTenUser]

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(users) { user in
                    RankingItem(
                        name: user.username,
                        score: user.place,
                        isTopUser: user.place == 1
                    )
                }
            }
            .padding()
        }
    }
}

struct RankingItem: View {
    let name: String
    let score: Int
    let isTopUser: Bool

    var body: some View {
        HStack {
            Text(name)
                .font(.headline)
                .foregroundColor(isTopUser ? .green : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            ZStack {
                Circle()
                    .fill(isTopUser ? Color.yellow : Color.gray.opacity(0.5))
                    .frame(width: 40, height: 40)

                Text("\(score)")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isTopUser ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
        )
        .shadow(radius: 2)
    }
}
