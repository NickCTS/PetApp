import SwiftUI

struct AddPetView: View {
    @State private var name: String = ""
    @State private var age: Int = 0
    @State private var breed: String = ""
    @State private var description: String = ""
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Breed", text: $breed)
            TextField("Description", text: $description)
            
            Stepper("Age: \(age)", value: $age)
            
            Button(action: {
                // Add pet logic here
                print("Pet added")
            }) {
                Text("Add Pet")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
