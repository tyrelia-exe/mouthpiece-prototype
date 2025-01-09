import SwiftUI
import AVKit
import FirebaseFirestore
import FirebaseAuth

struct CreatePostView: View {
    @Environment(\.dismiss) var dismiss
    @State private var caption = ""
    @State private var selectedImage: UIImage?
    @State private var selectedVideoURL: URL?
    @State private var isImagePickerPresented = false
    @State private var isVideoPickerPresented = false
    @State private var isUploading = false
    @State private var isVideo = false

    private let db = Firestore.firestore()
    private let userId = Auth.auth().currentUser?.uid

    var body: some View {
        NavigationView {
            VStack {
                // Media Preview
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                } else if let selectedVideoURL = selectedVideoURL {
                    VideoPlayer(player: AVPlayer(url: selectedVideoURL))
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                } else {
                    Button(action: {
                        isImagePickerPresented = true
                    }) {
                        Text("Add Photo or Video")
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }

                TextField("Write a caption...", text: $caption)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Spacer()

                Button(action: createPost) {
                    if isUploading {
                        ProgressView()
                    } else {
                        Text("Post")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .disabled((selectedImage == nil && selectedVideoURL == nil) || caption.isEmpty || isUploading)
                .padding()
            }
            .padding()
            .navigationTitle("Create Post")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                MediaPicker(
                    selectedImage: $selectedImage,
                    selectedVideoURL: $selectedVideoURL,
                    isVideo: $isVideo
                )
            }
        }
    }

    private func createPost() {
        guard let userId = userId else { return }
        isUploading = true

        if let selectedImage = selectedImage {
            uploadMediaToCloudinary(image: selectedImage) { url in
                savePostToDatabase(mediaURL: url, isVideo: false)
            }
        } else if let selectedVideoURL = selectedVideoURL {
            uploadMediaToCloudinary(videoURL: selectedVideoURL) { url in
                savePostToDatabase(mediaURL: url, isVideo: true)
            }
        }
    }

    private func savePostToDatabase(mediaURL: String, isVideo: Bool) {
        let postData: [String: Any] = [
            "userId": userId ?? "",
            "mediaURL": mediaURL,
            "isVideo": isVideo,
            "caption": caption,
            "timestamp": FieldValue.serverTimestamp(),
            "likesCount": 0,
            "commentsCount": 0
        ]

        db.collection("posts").addDocument(data: postData) { error in
            isUploading = false
            if let error = error {
                print("Error creating post: \(error.localizedDescription)")
            } else {
                dismiss()
            }
        }
    }

    private func uploadMediaToCloudinary(image: UIImage? = nil, videoURL: URL? = nil, completion: @escaping (String) -> Void) {
        // Set the correct endpoint
        guard let cloudinaryURL = URL(string: "https://api.cloudinary.com/v1_1/daq2d8tsr/\(image != nil ? "image/upload" : "video/upload")") else {
            print("Invalid Cloudinary URL")
            return
        }

        var request = URLRequest(url: cloudinaryURL)
        request.httpMethod = "POST"

        // Set boundary for multipart form data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        let fieldName = "file"
        let fileName = image != nil ? "image.jpg" : "video.mp4"
        let uploadPreset = "ml_default" // Replace with your actual preset name for unsigned uploads

        // Append file data
        if let image = image, let imageData = image.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        } else if let videoURL = videoURL, let videoData = try? Data(contentsOf: videoURL) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: video/mp4\r\n\r\n".data(using: .utf8)!)
            body.append(videoData)
            body.append("\r\n".data(using: .utf8)!)
        }

        // Append upload preset
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"upload_preset\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(uploadPreset)\r\n".data(using: .utf8)!)

        // Close the boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error uploading media: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Parse the response
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let mediaURL = json["secure_url"] as? String {
                DispatchQueue.main.async {
                    completion(mediaURL)
                }
            } else {
                // Print the response for debugging
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Cloudinary Response: \(responseString)")
                }
                print("Failed to parse Cloudinary response.")
            }
        }.resume()
    }
}
