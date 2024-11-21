import SwiftUICore
import FirebaseAuth
import SwiftUI

struct MainAppWithBottomNav: View {
    @State private var selectedScreen: Screen = .home
    var userInfo: User
    var onLogout: () -> Void

    var body: some View {
        TabView(selection: $selectedScreen) {
            UserProfileScreen(userInfo: userInfo, onLogout: onLogout)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(Screen.userProfile)
            
            HomeScreen()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(Screen.home)

            RankingScreen()
                .tabItem {
                    Label("Ranking", systemImage: "list.bullet")
                }
                .tag(Screen.ranking)
        }
    }
}

enum Screen {
    case home
    case userProfile
    case ranking
}
