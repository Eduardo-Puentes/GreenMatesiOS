import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var showLogin = true
    @State private var userInfo: User? = nil

    var body: some View {
        NavigationStack {
            if isLoggedIn, let user = userInfo {
                MainAppWithBottomNav(userInfo: user, onLogout: handleLogout)
            } else {
                if showLogin {
                    LoginScreen(
                        onLoginSuccess: { email, password in
                            signInWithFirebase(email: email, password: password) { success, fetchedUserInfo in
                                if success, let user = fetchedUserInfo {
                                    self.isLoggedIn = true
                                    self.userInfo = user
                                } else {
                                    print("Login failed.")
                                }
                            }
                        },
                        onNavigateToRegister: {
                            self.showLogin = false
                        }
                    )
                } else {
                    RegisterScreen(
                        onNavigateToLogin: {
                            self.showLogin = true
                        }
                    )
                }
            }
        }
    }

    private func handleLogout() {
        print("Handling logout...")
        isLoggedIn = false
        userInfo = nil
    }
}

func signInWithFirebase(email: String, password: String, completion: @escaping (Bool, User?) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
        if let error = error {
            print("Firebase login error: \(error.localizedDescription)")
            completion(false, nil)
            return
        }

        guard let firebaseUser = authResult?.user else {
            completion(false, nil)
            return
        }

        fetchUserFromBackend(uid: firebaseUser.uid) { fetchedUser in
            if let user = fetchedUser {
                completion(true, user)
            } else {
                completion(false, nil)
            }
        }
    }
}

func fetchUserFromBackend(uid: String, completion: @escaping (User?) -> Void) {
    ApiService.shared.getUser(uid: uid) { result in
        switch result {
        case .success(let userResponse):
            completion(userResponse.user)
        case .failure(let error):
            print("Error fetching user data from backend: \(error.localizedDescription) \(uid)")
            completion(nil)
        }
    }
}
