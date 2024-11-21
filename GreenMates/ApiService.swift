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

    func getAllCourses(completion: @escaping (Result<[Tallers], Error>) -> Void) {
        NetworkService.shared.get("/api/course", completion: completion)
    }
    
    func getAllRecolectas(completion: @escaping (Result<[Recolectas], Error>) -> Void) {
        NetworkService.shared.get("/api/recollect", completion: completion)
    }
    
    func fetchTopTenUsers(completion: @escaping (Result<[TopTenUser], Error>) -> Void) {
        NetworkService.shared.get("/api/topten") { (result: Result<TopTenArray, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.userArray))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}


