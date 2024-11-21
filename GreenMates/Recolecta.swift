import Foundation

struct Recolectas: Codable, Identifiable {
    let id = UUID()
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
        case RecollectID, CollaboratorFBID, Cardboard, Glass, Tetrapack, Plastic, Paper, Metal
        case StartTime, EndTime, Longitude, Latitude, Limit, DonationArray
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        RecollectID = try container.decode(String.self, forKey: .RecollectID)
        CollaboratorFBID = try container.decode(String.self, forKey: .CollaboratorFBID)
        Cardboard = try container.decode(Int.self, forKey: .Cardboard)
        Glass = try container.decode(Int.self, forKey: .Glass)
        Tetrapack = try container.decode(Int.self, forKey: .Tetrapack)
        Plastic = try container.decode(Int.self, forKey: .Plastic)
        Paper = try container.decode(Int.self, forKey: .Paper)
        Metal = try container.decode(Int.self, forKey: .Metal)
        Longitude = try container.decode(Double.self, forKey: .Longitude)
        Latitude = try container.decode(Double.self, forKey: .Latitude)
        Limit = try container.decode(Int.self, forKey: .Limit)
        DonationArray = try container.decode([Donation].self, forKey: .DonationArray)

        let startTimeString = try container.decode(String.self, forKey: .StartTime)
        let endTimeString = try container.decode(String.self, forKey: .EndTime)
        let dateFormatter = ISO8601DateFormatter()

        if let startTime = dateFormatter.date(from: startTimeString),
           let endTime = dateFormatter.date(from: endTimeString) {
            StartTime = startTime
            EndTime = endTime
        } else {
            throw DecodingError.dataCorruptedError(forKey: .StartTime, in: container, debugDescription: "Invalid date format")
        }
    }
}
