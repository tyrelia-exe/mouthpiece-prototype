import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authService: AuthenticationService // Authentication service to manage login/logout
    
    var body: some View {
        Group {
            if authService.isAuthenticated {
                MainAppView() // Main App View for authenticated users
            } else {
                AuthView() // Shows Login and Registration for unauthenticated users
            }
        }
        .animation(.easeInOut, value: authService.isAuthenticated) // Smooth transition
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationService()) // Mock AuthenticationService
    }
}
