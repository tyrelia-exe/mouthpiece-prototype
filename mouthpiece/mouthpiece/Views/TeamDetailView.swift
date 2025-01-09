//
//  TeamDetailView.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/8/24.
//


import SwiftUI

struct TeamDetailView: View {
    let team: Team

    var body: some View {
        VStack {
            Text(team.name)
                .font(.largeTitle)
                .padding()

            Text("Members:")
                .font(.headline)

            ForEach(team.members, id: \.self) { member in
                Text(member)
                    .padding(.top, 2)
            }

            Spacer()
        }
        .padding()
    }
}
