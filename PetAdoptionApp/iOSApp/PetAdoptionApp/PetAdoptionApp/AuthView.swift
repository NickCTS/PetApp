import SwiftUI

struct AuthView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var user: User?
    @State private var showAccountHome: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
                
                Button("Register") {
                    registerUser()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("Login") {
                    loginUser()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                NavigationLink(destination: AccountHomeView(user: user ?? User(id: 0, username: "Guest", email: "guest@example.com")), isActive: $showAccountHome) {
                    EmptyView()
                }
            }
            .padding()
        }
    
    }
    
    private func registerUser() {
        // Ensure the correct order: username, email, password
        let newUser = User(username: username, email: email, password: password)
        APIService.shared.registerUser(user: newUser) { result in
            switch result {
            case .success(let registeredUser):
                DispatchQueue.main.async {
                    self.user = registeredUser
                    self.showAccountHome = true
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func loginUser() {
        APIService.shared.loginUser(username: username, password: password) { result in
            switch result {
            case .success(let loggedInUser):
                DispatchQueue.main.async {
                    self.user = loggedInUser
                    self.showAccountHome = true
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct AccountHomeView: View {
    var user: User

    var body: some View {
        VStack {
            Text("Welcome, \(user.username)")
                .font(.largeTitle)
            Text("Email: \(user.email)")
        }
        .navigationTitle("Account Home")
    }
}
