//
//  LoginView.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/8/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authService: AuthenticationService
    @State private var showError = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Full-screen Background Color
                Color(#colorLiteral(red: 0.118, green: 0.078, blue: 1, alpha: 1)) // #1e14ff
                    .ignoresSafeArea() // Extends to safe areas

                VStack(spacing: 20) {
                    // Logo Image
                    Image("Mouthpiece_Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200) // Adjust size as needed
                        .padding(.bottom, 50)

                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)

                    // Email and Password Fields
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .padding(.horizontal, 30)

                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 30)

                    if showError, let errorMessage = authService.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    // Login Button
                    Button(action: login) {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 30)
                    }
                    .padding(.top, 10)

                    Spacer()

                    // Register Link
//                    HStack {
//                        Text("Don't have an account?")
//                            .foregroundColor(.white)
//                        Button(action: {
//                            // Navigate to Register
//                        }) {
//                            Text("Register")
//                                .foregroundColor(.white)
//                                .underline()
//                        }
//                    }
//                    .padding(.bottom, 20)
                }
                .frame(width: geometry.size.width, height: geometry.size.height) // Match the screen size
            }
        }
    }

    private func login() {
        authService.login(email: email, password: password) { success in
            if !success {
                showError = true
            }
        }
    }
}
