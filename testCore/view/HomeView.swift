import SwiftUI
import KeychainSwift

struct HomeView: View {
    @State private var isLoggedOut = false

    var body: some View {
        VStack {
            Button("Logout") {
                logoutUser()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(5.0)
            .padding(.top, 20)
        }
        .padding()
        .fullScreenCover(isPresented: $isLoggedOut) {
            LoginView()
        }
    }

    func logoutUser() {
        let keychain = KeychainSwift()
        keychain.delete(LoginView.loginKeychainKey)
        DispatchQueue.main.async {
            isLoggedOut = true 
        }
    }
}
