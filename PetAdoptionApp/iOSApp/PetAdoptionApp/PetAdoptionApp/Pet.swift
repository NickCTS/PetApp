struct Pet: Identifiable, Codable {
    let id: Int
    let name: String
    let type: String
    let breed: String?
    let age: Int?
    let description: String?
    let imageUrl: String?
}
