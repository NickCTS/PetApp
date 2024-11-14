import SwiftUI

@main
struct PetAdoptionAppApp: App {
    @StateObject var authContext = AuthContext()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authContext)
        }
    }
}
