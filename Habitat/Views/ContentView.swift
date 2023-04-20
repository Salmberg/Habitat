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
            TextField("Password", text: $password)

            Button(action: {
                authVM.signIn(email: email, password: password)
                //signedIn = true
            }) {
                Text("Sign in")
            }
            Button(action: {
                authVM.signUp(email: email, password: password)
                //signedIn = true
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
        Button(action: {
            authVM.signOut()
        }){
            Text("Sign out")
        }
        
            VStack {
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
                    TextField("Habit", text: $newHabitName)
                    Button("Add", action: {
                        habitsVM.saveHabit(habitName: newHabitName)
                        //habitsVM.listenToFirestore()
                    })
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
