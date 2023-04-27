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




struct HabitListView : View {
    @StateObject var habitsVM = HabitsVM()
    @State var showAddAlert = false
    @State var showDoneAlert = false
    @State var newHabitName = ""
    @ObservedObject var authVM : AuthViewModel

    @State var days = 1
    
    let db = Firestore.firestore()
    
    var body : some View {
        VStack {
            Button(action: {
                authVM.signOut()
            }) {
                Text("Sign out")
                
            }
            
            ScrollView {
                ForEach(habitsVM.habits) { habit in
                    RowView(habit: habit, vm: HabitsVM())
                        .listRowBackground(Color(.black))
                        .foregroundColor(.white )
                    
                }
               .onDelete() { IndexSet in
                   for index in IndexSet {
                       habitsVM.delete(index: index)
                   }
        }
            }
            .alert(isPresented: $showDoneAlert) {
                Alert(title: Text("Target Reached!"), message: Text("You have reached your target days."), dismissButton: .default(Text("OK")))
            }
            
            Button(action: {
                showAddAlert = true
            }) {
                Text("Add habit")
            }
            
            .alert("Add new habit", isPresented: $showAddAlert) {
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
        .background(Color(.black)
            .scaledToFill()
            .edgesIgnoringSafeArea(.all))
    }
    
    struct ProgressBar: View {
        let habit : Habit
        @Binding var progress: Float

        func updateProgress() {
                let habitProgress = Float(habit.days) == 0 ? 0.0 : Float(habit.procent) / Float(habit.days)
                self.progress = habitProgress
            }
        
        var body: some View {
            
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 20.0)
                    .opacity(0.3)
                    .foregroundColor(Color.red)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.red)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear)
                Text(habit.name)
                    .padding(.bottom, 50)
                    .bold()
            
                Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                    .font(.largeTitle)
                    .bold()
                Text("Dagar:\(habit.days)")
                    .padding(.top, 50)
            }
            .onAppear{
                updateProgress()
            }
        }
    }
    struct RowView: View {
        @State var progressValue: Float = 0.0
        @State var showAlert = false
        @State var showDoneAlert = false
        @State var habit: Habit
        let vm: HabitsVM
        
        var body: some View {
            HStack {
                ProgressBar(habit: habit, progress: self.$progressValue)
                    .frame(width: 150.0, height: 150.0)
                    .padding(20.0)
                    .padding(.leading, 120)
                Spacer()
                Button(action: {
                    vm.toggle(habit: &habit, showDoneAlert: showAlert)
                }) {
                    // Checkmark?
                }
            }
            Button(action: {
                self.incrementProgress()
                vm.toggle(habit: &habit, showDoneAlert: showAlert)
                if habit.days == habit.targetDays {
                    showDoneAlert = true
                } else if habit.days <= habit.targetDays {
                    habit.days += 1
                }
            }) {
                HStack {
                    Text("Utför")
                        .foregroundColor(.white)
                }
                .padding(15.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 15.0)
                        .stroke(lineWidth: 2.0)
                        .foregroundColor(.white)
                )
            }
            .alert(isPresented: $showDoneAlert) {
                Alert(title: Text("Congratulations!"), message: Text("You have completed your habit for 60 days."), dismissButton: .default(Text("OK")))
            }
        }
        
        func incrementProgress() {
            let randomValue = Float([0.012, 0.022, 0.034, 0.016, 0.11].randomElement()!)
            self.progressValue += randomValue
        }
    }


}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }
}




