import SwiftUI

struct RegisterView: View {
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var isLoading = false
    @State var errorMessage: String? = nil

    var body: some View {
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

    func registerUser() {
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "全てのフィールドを入力してください"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "パスワードが一致しません"
            return
        }

        let query = """

        """

        let url = URL(string: "うrl")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "query": query,
            "variables": [
                "username": username,
                "email": email,
                "password": password
            ]
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)


        isLoading = true
        errorMessage = nil


        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    errorMessage = "エラーが発生しました: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    errorMessage = "無効な応答"
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let errors = json["errors"] as? [[String: Any]] {
                        errorMessage = errors.first?["message"] as? String ?? "エラーが発生しました"
                    } else {
                        errorMessage = nil
                    }
                } catch {
                    errorMessage = "データ処理エラー: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
