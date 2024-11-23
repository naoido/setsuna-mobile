import Apollo
import SwiftUI
import RocketReserverAPI
import KeychainSwift

struct LoginView: View {
    static let loginKeychainKey = "login"
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false

    var body: some View {
        NavigationView {
            VStack {
                TextField("email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)

                Button(action: {
                    loginUser()
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5.0)
                }

                NavigationLink(destination: RegisterView()) {
                    Text("新規登録")
                }
            }
            .padding()
            .fullScreenCover(isPresented: $isLoggedIn) {
                MainView()
            }
        }
    }

    func loginUser() {
        let mutation = Post_loginMutation(email: email, password: password)
        let query = Get_userIDQuery()
        Network.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .success(let graphQLResult):
                if let token = graphQLResult.data?.post_login?.token {
                    let keychain = KeychainSwift()
                    keychain.set(token, forKey: LoginView.loginKeychainKey)
                    Network.shared.apollo.fetch(query: query) { result in
                        switch result {
                        case .success(let graphQLResult):
                            if let name = graphQLResult.data?.get_userID {
                                print(name) // Luke Skywalker
                            } else if let errors = graphQLResult.errors {
                                // GraphQL errors
                                print(errors)
                            }
                        case .failure(let error):
                            // Network or response format errors
                            print(error)
                        }
                    }
                    print("Token: \(token)")
                    print("---------------------------------------")
                    print(keychain.get(LoginView.loginKeychainKey) ?? "No token")
                    
                    DispatchQueue.main.async {
                        isLoggedIn = true
                    }
                } else if let errors = graphQLResult.errors {
                    print("GraphQL errors: \(errors)")
                }
            case .failure(let error):
                print("Network error: \(error)")
            }
        }
    }
}
