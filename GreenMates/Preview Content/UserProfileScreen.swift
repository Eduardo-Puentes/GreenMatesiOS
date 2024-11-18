import SwiftUI

struct UserProfileScreen: View {
    let userInfo: User

    var body: some View {
        VStack(spacing: 20) {
            Text("User Profile")
                .font(.largeTitle)
                .fontWeight(.bold)

            if let profileImageUrl = userInfo.profileImageUrl, !profileImageUrl.isEmpty {
                AsyncImage(url: URL(string: profileImageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
            }

            Text(userInfo.name)
                .font(.title2)
                .fontWeight(.semibold)

            Text(userInfo.email)
                .font(.subheadline)
                .foregroundColor(.gray)

            Spacer()
        }
        .padding()
    }
}
