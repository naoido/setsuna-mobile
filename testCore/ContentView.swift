import SwiftUI
import KeychainSwift
struct ContentView: View {

    var body: some View {
        Group {
            if isLoggedIn() {
                LoginView()
            } else {
                MainView()
            }
        }
    }
    private func isLoggedIn() -> Bool {
        let keychain = KeychainSwift()
        return keychain.get(LoginView.loginKeychainKey) != nil
    }
}
