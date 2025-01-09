//
//  Step5ProfilePictureAndBioView.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/8/24.
//


import SwiftUI
import _PhotosUI_SwiftUI

struct Step5ProfilePictureAndBioView: View {
    @Binding var bio: String
    @Binding var profilePicture: UIImage?
    @Binding var selectedProfilePicture: PhotosPickerItem?
    var onNext: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Add Your Profile Picture and Bio")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            // Profile Picture Picker
            VStack {
                if let profilePicture = profilePicture {
                    Image(uiImage: profilePicture)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 4)
                        )
                        .shadow(radius: 5)
                } else {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 150, height: 150)
                        .overlay(
                            Text("Add Picture")
                                .foregroundColor(.white)
                                .font(.headline)
                        )
                        .shadow(radius: 5)
                }
            }
            .onTapGesture {
                // Trigger PhotosPicker
            }
            .padding(.bottom)

            PhotosPicker(
                selection: $selectedProfilePicture,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Text("Select Profile Picture")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .onChange(of: selectedProfilePicture) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        profilePicture = image
                    }
                }
            }

            // Bio Input
            TextField("Write a short bio about yourself", text: $bio, axis: .vertical)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.white)
                .frame(maxHeight: 150)
                .shadow(radius: 5)

            Spacer()

            // Next Button
            Button(action: onNext) {
                Text("Finish")
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
}
