//
//  AuthView.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/8/24.
//

import SwiftUI

struct AuthView: View {
    @State private var isShowingLogin = true // Toggles between Login and Register

    var body: some View {
        ZStack {
            // Background Color
            Color(#colorLiteral(red: 0.118, green: 0.078, blue: 1, alpha: 1)) // #1e14ff
                .ignoresSafeArea() // Ensures the background covers the entire screen

            VStack {
                if isShowingLogin {
                    LoginView()
                } else {
                    RegistrationView()
                }

                // Toggle Button
                Button(action: {
                    isShowingLogin.toggle()
                }) {
                    Text(isShowingLogin ? "Don't have an account? Register" : "Already have an account? Login")
                        .foregroundColor(.white) // Updated for better visibility
                        .padding(.top, 20)
                }
            }
            .padding()
        }
    }
}
