import SwiftUI
import KeychainSwift
struct MainView: View {
    @State var selected = 1
    
    var body: some View {
        
        TabView(selection: $selected) {
            ShakeView()
                .tabItem {
                    Label("Shake", systemImage:"circle")
                }
                .tag(1)
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "circle")
                }
                .tag(2)
            GameView()
                .tabItem {
                    Label("Game", systemImage: "circle")
                }
                .tag(3)
        }
        .tabViewStyle(.page)
    }
    private func isLoggedIn() -> Bool {
        let keychain = KeychainSwift()
        return keychain.get(LoginView.loginKeychainKey) != nil
    }
}
