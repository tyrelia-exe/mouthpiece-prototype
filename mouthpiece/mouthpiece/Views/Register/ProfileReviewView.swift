import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileReviewView: View {
    var firstName: String
    var lastName: String
    var username: String
    var dateOfBirth: Date
    var gender: String
    var email: String
    var password: String
    var city: String
    var state: String
    var bio: String
    var profilePicture: UIImage?
    var selectedSport: String
    var primaryPosition: String
    var secondaryPosition: String
    var primaryPlaystyle: String
    var secondaryPlaystyle: String
    var playstyleTag: String
    var onRegisterSuccess: () -> Void 

    @EnvironmentObject var authService: AuthenticationService

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Review Your Information")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                VStack(alignment: .leading, spacing: 10) {
                    ProfileReviewRow(label: "First Name", value: firstName)
                    ProfileReviewRow(label: "Last Name", value: lastName)
                    ProfileReviewRow(label: "Username", value: username)
                    ProfileReviewRow(label: "Date of Birth", value: formattedDate(dateOfBirth))
                    ProfileReviewRow(label: "Gender", value: gender)
                    ProfileReviewRow(label: "Email", value: email)
                    ProfileReviewRow(label: "City", value: city)
                    ProfileReviewRow(label: "State", value: state)
                    ProfileReviewRow(label: "Bio", value: bio)
                    ProfileReviewRow(label: "Sport", value: selectedSport)
                    ProfileReviewRow(label: "Primary Position", value: primaryPosition)
                    ProfileReviewRow(label: "Secondary Position", value: secondaryPosition)
                    ProfileReviewRow(label: "Primary Playstyle", value: primaryPlaystyle)
                    ProfileReviewRow(label: "Secondary Playstyle", value: secondaryPlaystyle)
                    ProfileReviewRow(label: "Playstyle Tag", value: playstyleTag)
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .shadow(radius: 5)

                Button(action: registerAndSaveUser) {
                    Text("Confirm and Register")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
            .padding()
        }
        .background(Color(#colorLiteral(red: 0.118, green: 0.078, blue: 1, alpha: 1)))
        .ignoresSafeArea()
    }

    private func registerAndSaveUser() {
        // Register and authenticate the user
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Failed to create user: \(error.localizedDescription)")
                return
            }

            guard let user = authResult?.user else {
                print("Failed to retrieve authenticated user")
                return
            }

            print("User registered with UID: \(user.uid)")

            // Save user data to Firestore
            saveUserData(userId: user.uid)
        }
    }

    private func saveUserData(userId: String) {
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "username": username,
            "dateOfBirth": Timestamp(date: dateOfBirth),
            "gender": gender,
            "email": email,
            "city": city,
            "state": state,
            "bio": bio,
            "selectedSport": selectedSport,
            "primaryPosition": primaryPosition,
            "secondaryPosition": secondaryPosition,
            "primaryPlaystyle": primaryPlaystyle,
            "secondaryPlaystyle": secondaryPlaystyle,
            "playstyleTag": playstyleTag,
            "createdAt": Timestamp()
        ]

        db.collection("users").document(userId).setData(userData) { error in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
            } else {
                print("User data saved successfully.")
                authService.isAuthenticated = true // Update authentication state
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct ProfileReviewRow: View {
    var label: String
    var value: String

    var body: some View {
        HStack {
            Text(label + ":")
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .foregroundColor(.white)
        }
    }
}
