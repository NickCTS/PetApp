import SwiftUI
import Combine

class AuthContext: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var showLogin: Bool = true
    @Published var token: String?
    
    func login(token: String) {
        self.token = token
        self.isAuthenticated = true
        self.showLogin = false
    }
    
    func logout() {
        self.token = nil
        self.isAuthenticated = false
        self.showLogin = true
    }
}
