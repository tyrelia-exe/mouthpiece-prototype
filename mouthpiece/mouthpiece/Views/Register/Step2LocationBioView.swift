import SwiftUI
import PhotosUI

struct Step2LocationBioView: View {
    @Binding var city: String
    @Binding var state: String
    @Binding var bio: String
    @Binding var profilePicture: UIImage?
    @Binding var selectedProfilePicture: PhotosPickerItem?
    var onNext: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Where are you from?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            VStack(spacing: 15) {
                CustomTextField(placeholder: "City", text: $city)
                CustomTextField(placeholder: "State", text: $state)
                CustomTextField(placeholder: "Bio (Optional)", text: $bio)

                VStack {
                    if let profilePicture = profilePicture {
                        Image(uiImage: profilePicture)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 5)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }

                    Text("Add Profile Picture")
                        .foregroundColor(.white)
                        .font(.caption)
                }
                .onTapGesture {
                    // Open image picker logic here
                }
            }

            Button(action: onNext) {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

