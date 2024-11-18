import SwiftUI

struct GradientButton: View {
    var text: String
    var onClick: () -> Void
    var gradient: LinearGradient

    var body: some View {
        Button(action: onClick) {
            Text(text)
                .padding()
                .frame(maxWidth: .infinity)
                .background(gradient)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}
