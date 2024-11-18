import Foundation

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
