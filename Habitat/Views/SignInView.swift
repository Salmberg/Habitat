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
                    .font(.custom("PassionOne-Bold", size: 60))
                    .bold()
                    .padding(.top,110)
                Text("Sign in to make new habits")
                    .font(.custom("PermanentMarker-Regular", size: 17))
                    .padding(.bottom, 50)
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
                    .padding(.horizontal, 8)
                    .padding(.vertical,10)
                    .multilineTextAlignment(.center)
                
                
                
                SecureField("Password", text: $password)
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                    .background(Color.brown)
                    .cornerRadius(20)
                    .padding(.horizontal, 8)
                    .padding(.vertical,5)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
            
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
                            authVM.scheduleDailyNotification(hour: 9, minute: 0, identifier: "habitReminder", title: "Habit Reminder", body: "Don't forget to tap your habits to keep your streak!")
                        }
                    }
                }) {
                    Text("Sign in")
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity, minHeight: 44)
                .padding(.vertical, 10)
                .padding(.top, 50)

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
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity, minHeight: 44)
                .padding(.vertical, 10)
                
            }
            .frame(height: 100)
            .padding(.horizontal, 80)
            .padding(.bottom, 30)
        }
    }
}
