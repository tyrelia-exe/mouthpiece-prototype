//
//  ProfileStat.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/10/24.
//

import SwiftUICore


struct ProfileStat: View {
    var label: String
    var description: String

    var body: some View {
        VStack {
            Text(label)
                .font(.headline)
                .fontWeight(.bold)
            Text(description)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity) // Ensures even spacing for stats
    }
}
