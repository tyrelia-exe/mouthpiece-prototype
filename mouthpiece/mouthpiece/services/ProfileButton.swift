//
//  ProfileButton.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/10/24.
//

import SwiftUICore


struct ProfileButton: View {
    var label: String
    var icon: String
    var backgroundColor: Color
    var textColor: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.headline)
            Text(label)
                .font(.headline)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .foregroundColor(textColor)
        .cornerRadius(10)
    }
}
