import SwiftUI
import Firebase

@main
struct MouthpieceApp: App {
    @State private var showLaunchScreen = true
    
    // Initialize Firebase
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        
        WindowGroup {if showLaunchScreen {
            LaunchScreenView()
                .onAppear {
                    // Delay before showing MainAppView
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Adjust delay as needed
                        withAnimation {
                            showLaunchScreen = false
                        }
                    }
                }
        } else {
            ContentView()
                .environmentObject(AuthenticationService()) // Provide AuthenticationService to the app
        }
        }
    }
}
