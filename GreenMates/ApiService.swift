import Foundation

class ApiService {
    static let shared = ApiService()

    private let network = NetworkService.shared

    func getUser(uid: String, completion: @escaping (Result<UserResponse, Error>) -> Void) {
        network.get("/api/user/\(uid)", completion: completion)
    }

    func createUser(user: User, completion: @escaping (Result<UserResponse, Error>) -> Void) {
        network.post("/api/user", body: user, completion: completion)
    }

    func getAllCourses(completion: @escaping (Result<[getTaller], Error>) -> Void) {
        network.get("/api/course", completion: completion)
    }
}
