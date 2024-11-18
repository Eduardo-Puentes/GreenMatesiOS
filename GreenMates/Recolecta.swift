import Foundation

struct Recolecta: Codable, Identifiable {
    let id = UUID() // Unique identifier for SwiftUI ForEach
    let RecollectID: String
    let CollaboratorFBID: String
    let Cardboard: Int
    let Glass: Int
    let Tetrapack: Int
    let Plastic: Int
    let Paper: Int
    let Metal: Int
    let StartTime: Date
    let EndTime: Date
    let Longitude: Double
    let Latitude: Double
    let Limit: Int
    let DonationArray: [Donation]

    enum CodingKeys: String, CodingKey {
        case RecollectID
        case CollaboratorFBID
        case Cardboard
        case Glass
        case Tetrapack
        case Plastic
        case Paper
        case Metal
        case StartTime
        case EndTime
        case Longitude
        case Latitude
        case Limit
        case DonationArray
    }
}

struct Donation: Codable {
    let UserFBID: String
    let Username: String
    let Cardboard: Double
    let Glass: Double
    let Metal: Double
    let Paper: Double
    let Plastic: Double
    let Tetrapack: Double
}
