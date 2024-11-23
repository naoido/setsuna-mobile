import SwiftUI
import Foundation
import Apollo
import RocketReserverAPI
import KeychainSwift
struct RegisterView: View {
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var isLoading = false
    @State var isSuccess = false
    @State var errorMessage: String? = nil
    
    var body: some View {
        if isSuccess == true {
            MainView()
        } else {
            VStack {
                TextField("Username", text: $username)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.bottom, 20)
                }
                
                Button(action: {
                    registerUser()
                }) {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(5.0)
                    } else {
                        Text("新規登録")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(5.0)
                    }
                }
            }
            .padding()
        }

    }
    
    func registerUser() {
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "全てのフィールドを入力してください"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "パスワードが一致しません"
            return
        }
        let regimutation = Post_registerMutation(email:email, name: username, password: password)
        Network.shared.apollo.perform(mutation: regimutation) { result in
            switch result {
            case .success(let graphQLResult):
                if let token = graphQLResult.data?.post_register?.token {
                    isSuccess = true
                    let keychain = KeychainSwift()
                    keychain.set(token, forKey: LoginView.loginKeychainKey)
                    print(token) // Luke Skywalker
                } else if let errors = graphQLResult.errors {
                    // GraphQL errors
                    print(errors)
                }
            case .failure(let error):
                // Network or response format errors
                print(error)
            }
        }
    }
}
