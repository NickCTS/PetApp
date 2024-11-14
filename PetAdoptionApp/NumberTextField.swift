import SwiftUI

struct NumberTextField: View {
    @Binding var value: String

    var body: some View {
        TextField("Age", text: $value)
            .modifier(KeyboardModifier())
            .onReceive(value.publisher.collect()) { newValue in
                let filtered = newValue.filter { "0123456789".contains($0) }
                self.value = String(filtered)
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
    }
}

#if os(iOS)
struct KeyboardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.keyboardType(.numberPad)
    }
}
#else
struct KeyboardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content // No keyboard type on non-iOS platforms
    }
}
#endif

struct NumberTextField_Previews: PreviewProvider {
    static var previews: some View {
        NumberTextField(value: .constant(""))
    }
}
