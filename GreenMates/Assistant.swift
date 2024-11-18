import Foundation

struct Assistant: Codable {
    let userFBID: String
    let username: String
    let email: String
}

struct getTaller: Codable {
    let courseID: String
    let collaboratorFBID: String
    let title: String
    let pillar: String
    let startTime: Date
    let endTime: Date
    let longitude: Double
    let latitude: Double
    var limit: Int
    let assistantArray: [Assistant]
}

struct Notification: Codable {
    let notificationType: String
    let message: String
}

struct User: Codable {
    let userID: String
    let fbid: String
    let username: String
    let email: String
    let cardboard: Int
    let glass: Int
    let tetrapack: Int
    let plastic: Int
    let paper: Int
    let metal: Int
    let medalTrans: Int
    let medalEnergy: Int
    let medalConsume: Int
    let medalDesecho: Int
    let courses: [String]
    let courseIDArray: [String]
    let notificationArray: [Notification]?
}

struct UserResponse: Codable {
    let user: User
}
