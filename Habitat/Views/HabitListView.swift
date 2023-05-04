//
//  HabitListView.swift
//  Habitat
//
//  Created by David Salmberg on 2023-04-27.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift
import Firebase


struct HabitListView : View {
    @StateObject var habitsVM = HabitsVM()
    @State var showAddAlert = false
    @State var showDoneAlert = false
    @State var newHabitName = ""
    @State var showInfoAlert = false
    @ObservedObject var authVM : AuthViewModel
    let auth = Auth.auth()
    @Binding var signedIn: Bool
    
    
    @State var days = 1
    
    let db = Firestore.firestore()
    
    var body : some View {
        VStack {
            HStack {
                Button(action: {
                    authVM.signOut() // Call the signOut function from the AuthViewModel
                    signedIn = false // Set the signedIn variable to false
                }) {
                    Image(systemName: "arrow.left.to.line")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .foregroundColor(.white)
                
                Button(action: {
                    showInfoAlert = true
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.white)
                        .padding()
                }
                .alert(isPresented: $showInfoAlert) {
                   Alert(title: Text("How does it work?"), message: Text("This app helps you form healthy habits! Based on scientific studies that show it takes about 60 days to create a new habit, this app is designed to help you achieve your goals by completing one small habit each day for 60 days.You can only do the habit once a day. By making daily habits a part of your routine, you can integrate them seamlessly into your life and create lasting change. With this app, you can track your progress, stay motivated, and form healthy habits that stick for good!"), dismissButton: .default(Text("Lets go!")))
                }
            }
            
            
            ScrollView {
                ForEach(habitsVM.habits) { habit in
                    RowView(habit: habit, vm: habitsVM)
                        .listRowBackground(Color(.black))
                        .foregroundColor(.white )
                    
                    
                }
                .onDelete(perform: deleteItems)
                
            }
            
            Button(action: {
                showAddAlert = true
            }) {
                Image(systemName: "plus.app")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
            }
            .foregroundColor(.white)
            .font(.title)
            
            .alert("Add new habit", isPresented: $showAddAlert) {
                VStack {
                    TextField("Habit", text: $newHabitName)
                    Button("Add", action: {
                        habitsVM.saveHabit(habitName: newHabitName)
                        habitsVM.listenToFirestore()
                        newHabitName = ""
                        showAddAlert = false
                    })
                    Button("Cancel", action: {
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
    
    func deleteItems(at offsets: IndexSet) {
        guard let user = auth.currentUser else { return }
        let habitsRef = db.collection("users").document(user.uid).collection("habits")
        
        var deletedHabits = [Habit]()
        for index in offsets {
            let habit = habitsVM.habits[index]
            if let id = habit.id {
                habitsRef.document(id).delete { error in
                    if let error = error {
                        print("Error deleting habit: \(error.localizedDescription)")
                    } else {
                        deletedHabits.append(habit)
                    }
                }
            }
        }
        habitsVM.habits = habitsVM.habits.filter { !deletedHabits.contains($0) }
        habitsVM.listenToFirestore()
        
        
        
    }
}
