import Foundation

struct UserResponse: Codable {
    let user: User
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
    let notificationArray: [Notification]?

    enum CodingKeys: String, CodingKey {
        case userID = "UserID"
        case fbid = "FBID"
        case username = "Username"
        case email = "Email"
        case cardboard = "Cardboard"
        case glass = "Glass"
        case tetrapack = "Tetrapack"
        case plastic = "Plastic"
        case paper = "Paper"
        case metal = "Metal"
        case medalTrans = "MedalTrans"
        case medalEnergy = "MedalEnergy"
        case medalConsume = "MedalConsume"
        case medalDesecho = "MedalDesecho"
        case notificationArray = "NotificationArray"
    }
}

struct Notification: Codable {
    let notificationType: String
    let message: String

    enum CodingKeys: String, CodingKey {
        case notificationType = "NotificationType"
        case message = "Message"
    }
}
