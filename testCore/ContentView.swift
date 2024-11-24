import SwiftUI
import KeychainSwift
struct ContentView: View {

    var body: some View {
        Group {
            if isLoggedIn() {
                MainView()
            } else {
                LoginView()
            }
        }
    }
    private func isLoggedIn() -> Bool {
        let keychain = KeychainSwift()
        return keychain.get(LoginView.loginKeychainKey) != nil
    }
}
