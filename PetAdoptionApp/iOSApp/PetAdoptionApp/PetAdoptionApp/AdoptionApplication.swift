import Foundation

struct AdoptionApplication: Identifiable, Codable {
    var id: Int
    var petId: Int
    var userId: Int
    var status: String
    var petName: String
    var petBreed: String
    var submittedAt: String
}
