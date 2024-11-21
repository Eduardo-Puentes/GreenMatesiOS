import Foundation
import MapKit

struct Assistant: Codable {
    let UserFBID: String
    let Username: String
    let Email: String
}

struct getTaller: Codable {
    let CourseID: String
    let CollaboratorFBID: String
    let Title: String
    let Pillar: String
    let StartTime: Date
    let EndTime: Date
    let Longitude: Double
    let Latitude: Double
    var Limit: Int
    let AssistantArray: [Assistant]
}

struct TopTenUser: Codable, Identifiable {
    let id: String
    let username: String
    let email: String
    let place: Int

    enum CodingKeys: String, CodingKey {
        case id = "UserFBID"
        case username = "Username"
        case email = "Email"
        case place = "Place"
    }
}

struct TopTenArray: Codable {
    let userArray: [TopTenUser]

    enum CodingKeys: String, CodingKey {
        case userArray = "UserArray"
    }
}

import Foundation

struct Tallers: Codable, Identifiable {
    let id = UUID()
    let CourseID: String
    let CollaboratorFBID: String
    let Title: String
    let Pillar: String
    let StartTime: Date
    let EndTime: Date
    let Longitude: Double
    let Latitude: Double
    let Limit: Int
    let AssistantArray: [Assistant]

    enum CodingKeys: String, CodingKey {
        case CourseID
        case CollaboratorFBID
        case Title
        case Pillar
        case StartTime
        case EndTime
        case Longitude
        case Latitude
        case Limit
        case AssistantArray
    }
}

extension Tallers {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        CourseID = try container.decode(String.self, forKey: .CourseID)
        CollaboratorFBID = try container.decode(String.self, forKey: .CollaboratorFBID)
        Title = try container.decode(String.self, forKey: .Title)
        Pillar = try container.decode(String.self, forKey: .Pillar)

        let dateFormatter = ISO8601DateFormatter()
        let startTimeString = try container.decode(String.self, forKey: .StartTime)
        let endTimeString = try container.decode(String.self, forKey: .EndTime)
        
        StartTime = dateFormatter.date(from: startTimeString) ?? Date()
        EndTime = dateFormatter.date(from: endTimeString) ?? Date()

        Longitude = try container.decode(Double.self, forKey: .Longitude)
        Latitude = try container.decode(Double.self, forKey: .Latitude)
        Limit = try container.decode(Int.self, forKey: .Limit)
        AssistantArray = try container.decode([Assistant].self, forKey: .AssistantArray)
    }
}




