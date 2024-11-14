import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            PetListView()
                .tabItem {
                    Label("Pets", systemImage: "pawprint.fill")
                }
            
            MyApplicationsView()
                .tabItem {
                    Label("Applications", systemImage: "doc.text.fill")
                }
            
            AuthView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle")
                }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
