//
//  AuthViewModel.swift
//  Habitat
//
//  Created by David Salmberg on 2023-04-20.
//

import Foundation
import Firebase

class AuthState: ObservableObject {
    @Published var isSignedIn = false
}

class AuthViewModel : ObservableObject{

    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Handle sign-in error
                print(error.localizedDescription)
            } else {
                // User successfully signed in
                print("User signed in.")
            }
        }
    }

    // Sign up with email and password
    func signUp(email: String, password: String) {
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
            if let error = error {
                // Handle sign-up error
                print(error.localizedDescription)
            } else if let methods = methods, !methods.isEmpty {
                // A user with this email already exists
                print("User with email already exists.")
            } else {
                // Create new user with email and password
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        // Handle sign-up error
                        print(error.localizedDescription)
                    } else {
                        // User successfully signed up
                        print("User signed up.")
                    }
                }
            }
        }
    }

    
    // Sign out
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
}
