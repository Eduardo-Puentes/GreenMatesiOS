import SwiftUI

struct RegisterScreen: View {
    var onNavigateToLogin: () -> Void

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Register")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button(action: {
                if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                    errorMessage = "Please fill in all fields."
                } else if password != confirmPassword {
                    errorMessage = "Passwords do not match."
                } else {
                    errorMessage = ""
                    // Call Firebase or backend API to register the user
                    print("Registering user with email: \(email)")
                }
            }) {
                Text("Register")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Button(action: {
                onNavigateToLogin()
            }) {
                Text("Already have an account? Login")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}
