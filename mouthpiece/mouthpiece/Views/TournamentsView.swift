//
//  TournamentsView.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/8/24.
//


import SwiftUI

struct TournamentsView: View {
    @StateObject private var tournamentViewModel = TournamentViewModel()

    var body: some View {
        NavigationView {
            List(tournamentViewModel.tournaments) { tournament in
                NavigationLink(destination: TournamentDetailView(tournament: tournament)) {
                    Text(tournament.name)
                        .font(.headline)
                }
            }
            .navigationTitle("Tournaments")
            .onAppear {
                tournamentViewModel.fetchTournaments()
            }
        }
    }
}
