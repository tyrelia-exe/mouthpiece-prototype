import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var location = ""
    @State private var profileImage: UIImage? = nil
    @State private var isImagePickerPresented = false

    private let db = Firestore.firestore()
    private let userId = Auth.auth().currentUser?.uid

    var body: some View {
        VStack(spacing: 20) {
            // Profile Picture
            if let profileImage = profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    .onTapGesture {
                        isImagePickerPresented = true
                    }
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 100, height: 100)
                    .onTapGesture {
                        isImagePickerPresented = true
                    }
            }

            // Name Field
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            // Location Field
            TextField("Location", text: $location)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Spacer()

            // Save Button
            Button(action: saveProfile) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                
            }
            .padding()
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $profileImage)
        }
        .onAppear(perform: fetchUserProfile)
        .navigationTitle("Edit Profile")
    }

    private func fetchUserProfile() {
        guard let userId = userId else { return }
        db.collection("users").document(userId).getDocument { snapshot, error in
            guard let data = snapshot?.data() else { return }
            name = data["name"] as? String ?? ""
            location = data["location"] as? String ?? ""
            // Load existing profile image (if needed)
        }
    }

    private func saveProfile() {
        guard let userId = userId else { return }
        if let profileImage = profileImage {
            // Upload image to Cloudinary
            CloudinaryUploader.uploadImage(profileImage) { result in
                switch result {
                case .success(let url):
                    updateFirestoreProfile(name: name, location: location, profilePictureURL: url)
                case .failure(let error):
                    print("Failed to upload image: \(error.localizedDescription)")
                }
            }
        } else {
            updateFirestoreProfile(name: name, location: location, profilePictureURL: nil)
        }
    }

    private func updateFirestoreProfile(name: String, location: String, profilePictureURL: String?) {
        var updatedData: [String: Any] = [
            "name": name,
            "location": location
        ]
        if let profilePictureURL = profilePictureURL {
            updatedData["profilePictureURL"] = profilePictureURL
        }

        db.collection("users").document(userId ?? "").updateData(updatedData) { error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
            } else {
                print("Profile updated successfully")
                dismiss()
            }
        }
    }
}
