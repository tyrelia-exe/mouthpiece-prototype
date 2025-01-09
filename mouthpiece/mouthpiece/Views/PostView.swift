//
//  PostView.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/9/24.
//


import SwiftUI
struct PostView: View {
    let post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // User Info
            HStack {
                // Placeholder for profile picture
                Circle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 40, height: 40)

                VStack(alignment: .leading) {
                    Text(post.userId) // Replace with username lookup
                        .font(.headline)
                    Text(post.timestamp, style: .time)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
            }

            // Content
            AsyncImage(url: URL(string: post.contentImageURL)) { image in
                image.resizable()
                     .scaledToFit()
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 300)
            }

            // Caption
            if !post.caption.isEmpty {
                Text(post.caption)
                    .font(.body)
            }

            // Stats
            HStack {
                Text("\(post.likesCount) Likes")
                    .font(.caption)
                Text("\(post.commentsCount) Comments")
                    .font(.caption)
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
