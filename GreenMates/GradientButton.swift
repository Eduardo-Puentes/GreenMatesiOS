import SwiftUI

struct GradientButton: View {
    let text: String
    let colors: [Color]
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing)
            .frame(height: 50)
            .cornerRadius(8)
            .overlay(
                Text(text)
                    .foregroundColor(.white)
                    .font(.headline)
            )
    }
}
