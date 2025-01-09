//
//  GridView.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/10/24.
//


import SwiftUI

struct GridView: View {
    let title: String
    let posts: [Post]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.leading)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                ForEach(posts) { post in
                    VStack {
                        if let url = URL(string: post.contentImageURL) {
                            AsyncImage(url: url) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                Rectangle().fill(Color.gray.opacity(0.5))
                            }
                            .frame(height: 100)
                            .cornerRadius(8)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
