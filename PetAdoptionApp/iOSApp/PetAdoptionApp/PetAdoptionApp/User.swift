import Foundation

struct User: Codable, Identifiable {
    var id: Int
    var username: String
    var email: String
    var password: String?
    
    init(id: Int = 0, username: String, email: String, password: String? = nil) {
        self.id = id
        self.username = username
        self.email = email
        self.password = password
    }
}
