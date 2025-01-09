//
//  AuthenticationService.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/8/24.
//


import FirebaseAuth

class AuthenticationService: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?

    func register(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            self.isAuthenticated = true
            completion(true)
        }
    }

    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            self.isAuthenticated = true
            completion(true)
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
