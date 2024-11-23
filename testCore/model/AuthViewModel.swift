import SwiftUI

struct User: Codable {
    let email: String
    let password: String
}

struct JWTResponse: Codable {
    let token: String
}


class AuthViewModel: ObservableObject {
    @Published var isLogin = false
    @Published var jwtToken: String? = nil

    func login(email: String, password: String) {
        let url = URL(string: "url")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let user = User(email: email, password: password)
        guard let httpBody = try? JSONEncoder().encode(user) else { return }

        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error:", error?.localizedDescription ?? "Unknown error")
                return
            }

            if let jwtResponse = try? JSONDecoder().decode(JWTResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.jwtToken = jwtResponse.token
                    self.isLogin = true
                }
            } else {
                print("Invalid response from server.")
            }
        }.resume()
    }

    func logout() {
        jwtToken = nil
        isLogin = false
    }
}
