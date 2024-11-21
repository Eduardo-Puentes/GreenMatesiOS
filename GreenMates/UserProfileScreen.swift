import SwiftUI
import CoreImage.CIFilterBuiltins
import FirebaseAuth

struct UserProfileScreen: View {
    let userInfo: User
    var onLogout: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(userInfo.username)
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(userInfo.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                if let qrCodeImage = generateQRCode(from: userInfo.fbid) {
                    Image(uiImage: qrCodeImage)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                }

                Button(action: handleLogout) {
                    Text("Cerrar Sesión")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)

                HStack {
                    Text("Medallas totales:")
                        .font(.title3)
                        .fontWeight(.bold)

                    Text("\(calculateTotalMedals(user: userInfo))")
                        .font(.title3)
                        .foregroundColor(.green)
                }

                MedalsSection(
                    mt: userInfo.medalTrans,
                    me: userInfo.medalEnergy,
                    mc: userInfo.medalConsume,
                    md: userInfo.medalDesecho
                )

                if let notifications = userInfo.notificationArray, !notifications.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Notificaciones")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top)

                        ForEach(notifications, id: \.message) { notification in
                            AchievementItem(notification: notification)
                        }
                    }
                } else {
                    Text("No achievements yet.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()
            }
            .padding()
        }
    }

    private func handleLogout() {
        do {
            try Auth.auth().signOut()
            print("User logged out successfully")
            onLogout()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    private func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }

    private func calculateTotalMedals(user: User) -> Int {
        return user.medalTrans + user.medalEnergy + user.medalConsume + user.medalDesecho
    }
}


struct MedalsSection: View {
    let mt: Int
    let me: Int
    let mc: Int
    let md: Int

    var body: some View {
        HStack(spacing: 20) {
            MedalItem(imageName: "bronze_medal", count: mt)
            MedalItem(imageName: "blue_medal", count: me)
            MedalItem(imageName: "gold_medal", count: mc)
            MedalItem(imageName: "purple_medal", count: md)
        }
        .padding(.top)
    }
}

struct MedalItem: View {
    let imageName: String
    let count: Int

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)

            Text("\(count)")
                .font(.headline)
                .foregroundColor(.black)
        }
    }
}


struct AchievementItem: View {
    let notification: Notification

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(notification.notificationType)
                    .font(.headline)
                Text(notification.message)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Image(getMedalImage(for: notification.notificationType))
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
    }

    private func getMedalImage(for type: String) -> String {
        switch type {
        case "ENERGIA": return "gold_medal"
        case "TRANSPORTE": return "purple_medal"
        case "CONSUMO": return "blue_medal"
        default: return "bronze_medal"
        }
    }
}

