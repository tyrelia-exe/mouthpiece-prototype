//
//  TeamsView.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/8/24.
//


import SwiftUI

struct TeamsView: View {
    @StateObject private var teamViewModel = TeamViewModel()

    var body: some View {
        NavigationView {
            List(teamViewModel.teams) { team in
                NavigationLink(destination: TeamDetailView(team: team)) {
                    Text(team.name)
                        .font(.headline)
                }
            }
            .navigationTitle("Teams")
            .onAppear {
                teamViewModel.fetchTeams()
            }
        }
    }
}
