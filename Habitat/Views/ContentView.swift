//
//  ContentView.swift
//  Habitat
//
//  Created by David Salmberg on 2023-04-19.
//

import SwiftUI
import FirebaseFirestoreSwift
import Firebase



struct ContentView : View {
    @StateObject var authVM = AuthViewModel()
    
    @State var signedIn = false
    
    var body: some View {
        if !signedIn {
            SignInView(signedIn: $signedIn, authVM: authVM)
        } else {
            HabitListView(authVM: authVM)
        }
    }
    
}

struct SignInView : View {
    @Binding var signedIn : Bool
    var auth = Auth.auth()
    @State var email : String = ""
    @State var password : String = ""
    @ObservedObject var authVM : AuthViewModel
    
    var body : some View {
        VStack {
            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            SecureField("Password", text: $password)
            
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
            }
        }
    }
}



struct HabitListView : View {
    @StateObject var habitsVM = HabitsVM()
    @State var showAddAlert = false
    @State var newHabitName = ""
    @ObservedObject var authVM : AuthViewModel
    
    let db = Firestore.firestore()
    
    var body : some View {
        VStack {
            Button(action: {
                authVM.signOut()
            }) {
                Text("Sign out")
            }
            
            List {
                ForEach(habitsVM.habits) { habit in
                    RowView(habit: habit, vm: habitsVM)
                }
            }
            
            Button(action: {
                showAddAlert = true
            }) {
                Text("Add habit")
            }
            
            .alert("Add", isPresented: $showAddAlert) {
                VStack {
                    TextField("Habit", text: $newHabitName)
                    Button("Add", action: {
                        habitsVM.saveHabit(habitName: newHabitName)
                        habitsVM.listenToFirestore()
                        newHabitName = ""
                        showAddAlert = false
                    })
                }
            }
        }
        .onAppear {
            habitsVM.listenToFirestore()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



struct RowView: View {
    let habit : Habit
    let vm : HabitsVM
    
    var body: some View {
        HStack{
            Text(habit.name)
            Spacer()
            Button(action: {
                vm.toggle(habit: habit)
            }) {
                //Checkmark?
            }
        }
    }
}
