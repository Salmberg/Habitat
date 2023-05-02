//
//  SignInView.swift
//  Habitat
//
//  Created by David Salmberg on 2023-04-27.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift
import Firebase


struct SignInView : View {
    @Binding var signedIn : Bool
    var auth = Auth.auth()
    @State var email : String = ""
    @State var password : String = ""
    @ObservedObject var authVM : AuthViewModel

    
    var body : some View {
        ZStack {
            Image("second image")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .offset(x: -80)
            
            
            VStack {
                Text("Habitat")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top,110)
                Text("Sign in to make new habits")
                    .font(.footnote)
                Spacer()
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .foregroundColor(.black)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                    .background(Color.brown)
                    .cornerRadius(20)
                    .padding(.horizontal, 60)
                    .padding(.vertical,10)
                    .multilineTextAlignment(.center)
                
                
                
                SecureField("Password", text: $password)
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                    .background(Color.brown)
                    .cornerRadius(20)
                    .padding(.horizontal, 60)
                    .padding(.vertical,5)
                    .multilineTextAlignment(.center)
                
                
                
                Button(action: {
                    if !email.isEmpty && !password.isEmpty {
                        auth.signIn(withEmail: email, password: password) { result, error in
                            if let error = error {
                                // Handle sign in error
                                print("Error signing in: \(error.localizedDescription)")
                            } else {
                                // Sign in success
                                signedIn = true
                            }
                        }
                    }
                }) {
                    Text("Sign in")
                        .background(Color(.black))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .padding(.top, 50)
                }
                Button(action: {
                    if !email.isEmpty && !password.isEmpty {
                        auth.createUser(withEmail: email, password: password) { result, error in
                            if let error = error {
                                // Handle sign up error
                                print("Error signing up: \(error.localizedDescription)")
                            } else {
                                // Sign up success
                                signedIn = true
                            }
                        }
                    }
                }) {
                    Text("Sign up")
                        .background(Color(.black))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .frame(height: 44)
                .padding(.bottom, 40)
            }
        }
    }
}
