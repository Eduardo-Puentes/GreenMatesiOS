struct MainAppWithBottomNav: View {
    @State private var selectedScreen: Screen = .home
    var userInfo: User

    var body: some View {
        TabView(selection: $selectedScreen) {
            HomeScreen()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(Screen.home)

            UserProfileScreen(userInfo: userInfo)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(Screen.userProfile)

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
