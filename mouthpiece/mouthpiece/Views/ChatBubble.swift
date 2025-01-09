//
//  ChatBubble.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/9/24.
//
import SwiftUI

// MARK: - ChatBubble View
struct ChatBubble: View {
    let message: String
    let isCurrentUser: Bool

    var body: some View {
        HStack {
            if isCurrentUser {
                Spacer()
                Text(message)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(maxWidth: 250, alignment: .trailing)
            } else {
                Text(message)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .frame(maxWidth: 250, alignment: .leading)
                Spacer()
            }
        }
        .padding(isCurrentUser ? .leading : .trailing, 50)
        .padding(.vertical, 5)
    }
}
