import SwiftUI

struct MyApplicationsView: View {
    @State private var applications: [AdoptionApplication] = []
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                if let error = errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                }
                
                List(applications, id: \.id) { application in
                    VStack(alignment: .leading) {
                        Text("Pet ID: \(application.petId)")
                            .font(.headline)
                        Text("Status: \(application.status ?? "Pending")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }

                .onAppear {
                    fetchApplications()
                }
            }
            .navigationTitle("My Applications")
        }
    }
    
    private func fetchApplications() {
        let userID = 1 // Replace with dynamic user ID after login
        APIService.shared.fetchUserApplications(userID: userID) { result in
            switch result {
            case .success(let fetchedApplications):
                DispatchQueue.main.async {
                    self.applications = fetchedApplications
                    self.errorMessage = nil
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
