//
//  AuthViewModel.swift
//  Habitat
//
//  Created by David Salmberg on 2023-04-20.
//

import Foundation
import Firebase

class AuthViewModel : ObservableObject{
    
   
    
    // Sign in with email and password
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                
            } else {
            }
        }
    }
    
    // Sign up with email and password
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                
            } else {
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
