//
//  PostCreatorView.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/8/24.
//


import SwiftUI

struct PostCreatorView: View {
    @State private var caption: String = ""

    var body: some View {
        VStack {
            TextField("Enter caption...", text: $caption)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding()

            Button("Post") {
                // Add post creation logic here
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
