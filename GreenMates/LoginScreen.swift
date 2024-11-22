import SwiftUI

struct LoginScreen: View {
    var onLoginSuccess: (String, String) -> Void
    var onNavigateToRegister: () -> Void

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack {
            Text("Inicia Sesión")
                .font(.title)
                .padding(.bottom, 20)

            TextField("Usuario", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)

            SecureField("Contraseña", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 10)
            }

            Button(action: {
                if email.isEmpty || password.isEmpty {
                    errorMessage = "Please fill in all fields."
                } else {
                    errorMessage = nil
                    onLoginSuccess(email, password)
                }
            }) {
                GradientButton(text: "Iniciar Sesión", colors: [Color.yellow, Color.green])
            }
            .padding(.top, 20)

            Text("o")
                .padding(.top, 20)

            Button(action: {
                onNavigateToRegister()
            }) {
                GradientButton(text: "Crear Cuenta", colors: [Color.green, Color.green])
            }
            .padding(.top, 20)

            Spacer()
        }
        .padding()
    }
}

