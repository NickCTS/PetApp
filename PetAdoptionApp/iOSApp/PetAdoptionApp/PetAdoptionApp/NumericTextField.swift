import SwiftUI

struct NumericTextField: View {
    @Binding var value: String

    var body: some View {
        TextField("Enter a number", text: $value)
            #if os(iOS)
            .keyboardType(.numberPad)
            #endif
            .onReceive(value.publisher.collect()) { newValue in
                // Filter out non-numeric characters and convert to String
                let filtered = newValue.filter { "0123456789".contains($0) }
                self.value = String(filtered)
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
    }
}

struct NumericTextField_Previews: PreviewProvider {
    static var previews: some View {
        NumericTextField(value: .constant(""))
            .padding()
    }
}
