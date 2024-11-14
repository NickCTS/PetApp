import SwiftUI

struct PetListView: View {
    @State private var pets: [Pet] = []
    @State private var favoritePetIDs: Set<Int> = []
    
    var body: some View {
        NavigationView {
            List(pets, id: \.id) { pet in
                VStack(alignment: .leading) {
                    Text(pet.name ?? "Unknown Name")
                        .font(.headline)
                    
                    Text("Type: \(pet.type ?? "Unknown Type")")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("Breed: \(pet.breed ?? "Unknown Breed")")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("Age: \(pet.age ?? 0) years")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(pet.description ?? "No description available")
                        .font(.body)
                    
                    Button(action: {
                        toggleFavorite(for: pet)
                    }) {
                        Text(favoritePetIDs.contains(pet.id) ? "Unfavorite" : "Favorite")
                            .foregroundColor(favoritePetIDs.contains(pet.id) ? .red : .blue)
                    }
                }
                .padding()
            }
            .navigationTitle("Pet List")
            .onAppear {
                fetchPets()
            }
        }
    }
    
    private func fetchPets() {
        APIService.shared.fetchPets { result in
            switch result {
            case .success(let fetchedPets):
                DispatchQueue.main.async {
                    self.pets = fetchedPets
                }
            case .failure(let error):
                print("Error fetching pets:", error.localizedDescription)
            }
        }
    }
    
    private func toggleFavorite(for pet: Pet) {
        if favoritePetIDs.contains(pet.id) {
            favoritePetIDs.remove(pet.id)
        } else {
            favoritePetIDs.insert(pet.id)
        }
    }
}

struct PetListView_Previews: PreviewProvider {
    static var previews: some View {
        PetListView()
    }
}
