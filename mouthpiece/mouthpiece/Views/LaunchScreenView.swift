//
//  LaunchScreenView.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/10/24.
//


import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.118, green: 0.078, blue: 1, alpha: 1)) // #1e14ff
                .edgesIgnoringSafeArea(.all)
            Image("Mouthpiece_Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200) 
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
