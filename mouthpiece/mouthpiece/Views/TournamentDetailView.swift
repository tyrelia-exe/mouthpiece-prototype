//
//  TournamentDetailView.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/8/24.
//


import SwiftUI

struct TournamentDetailView: View {
    let tournament: Tournament

    var body: some View {
        VStack {
            Text(tournament.name)
                .font(.largeTitle)
                .padding()

            Text("Start Date: \(tournament.startDate, formatter: dateFormatter)")
            Text("End Date: \(tournament.endDate, formatter: dateFormatter)")

            Text("Participants:")
                .font(.headline)

            ForEach(tournament.participants, id: \.self) { participant in
                Text(participant)
            }

            Spacer()
        }
        .padding()
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}
