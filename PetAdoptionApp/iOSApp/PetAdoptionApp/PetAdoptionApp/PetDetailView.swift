import SwiftUI

struct PetDetailView: View {
    let pet: Pet
    @State private var isFavorite: Bool = false
    
    var body: some View {
        VStack {
            Text(pet.name)
                .font(.largeTitle)
                .padding(.top)
            
            
            Button(action: {
                if isFavorite {
                    // Call API to remove from favorites
                    APIService.shared.removeFavorite(userID: 1, petID: pet.id) { success in
                        if success { isFavorite = false }
                    }
                } else {
                    // Call API to add to favorites
                    APIService.shared.addFavorite(userID: 1, petID: pet.id) { success in
                        if success { isFavorite = true }
                    }
                }
            }) {
                Text(isFavorite ? "Remove from Favorites" : "Add to Favorites")
                    .padding()
                    .background(isFavorite ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top)
        }
        .padding()
        .onAppear {
            // Check if the pet is already a favorite
            APIService.shared.fetchFavoritePets(userID: 1) { result in
                switch result {
                case .success(let pets):
                    isFavorite = pets.contains(where: { $0.id == pet.id })
                case .failure(let error):
                    print("Error fetching favorites: \(error)")
                }
            }
        }
    }
}
