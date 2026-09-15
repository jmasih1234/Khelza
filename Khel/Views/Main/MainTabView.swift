import SwiftUI

struct MainTabView: View {
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState
        TabView(selection: $appState.selectedTab) {
            Tab("Home", systemImage: "house.fill", value: .home) {
                HomeView()
                    .environment(appState)
            }
            
            Tab("Learn", systemImage: "book.fill", value: .learn) {
                LearnView()
                    .environment(appState)
            }
            
            Tab("Live", systemImage: "antenna.radiowaves.left.and.right", value: .live) {
                LiveView()
                    .environment(appState)
            }
            
            Tab("Games", systemImage: "gamecontroller.fill", value: .games) {
                GamesView()
                    .environment(appState)
            }
            
            Tab("Profile", systemImage: "person.fill", value: .profile) {
                ProfileView()
                    .environment(appState)
            }
        }
    }
}

#Preview {
    MainTabView()
        .environment(AppState())
}
