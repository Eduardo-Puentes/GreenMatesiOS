//
//  RankingScreen.swift
//  GreenMates
//
//  Created by base on 15/11/24.
//


import SwiftUI

struct RankingScreen: View {
    // Example data
    let rankings: [Ranking] = [
        Ranking(name: "John Doe", score: 120),
        Ranking(name: "Jane Smith", score: 110),
        Ranking(name: "Alex Johnson", score: 105)
    ]

    var body: some View {
        VStack(spacing: 20) {
            Text("Ranking")
                .font(.largeTitle)
                .fontWeight(.bold)

            List(rankings) { ranking in
                HStack {
                    Text(ranking.name)
                        .font(.body)
                    Spacer()
                    Text("\(ranking.score) pts")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding()
    }
}

struct Ranking: Identifiable {
    let id = UUID()
    let name: String
    let score: Int
}
