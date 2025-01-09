//
//  VideoPlayerView.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/10/24.
//


import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let videoURL: URL

    var body: some View {
        VideoPlayer(player: AVPlayer(url: videoURL))
            .frame(height: 200) // Adjust height as needed
            .cornerRadius(10)
    }
}
