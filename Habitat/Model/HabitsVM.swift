//
//  HabitsVM.swift
//  Habitat
//
//  Created by David Salmberg on 2023-04-20.
//

import Foundation
import Firebase
import SwiftUI

class HabitsVM : ObservableObject {
    let db = Firestore.firestore()
    let auth = Auth.auth()

    
    @Published var habits = [Habit]()
    
    func delete(index: Int) {
        guard let user = auth.currentUser else {return}
        let habitsRef = db.collection("users").document(user.uid).collection("habits")
        
        let habit = habits[index]
        if let id = habit.id {
            habitsRef.document(id).delete { error in
                if let error = error {
                    print("Error deleting habit: \(error.localizedDescription)")
                } else {
                    self.habits.remove(at: index) // Remove habit from array
                }
            }
        }
    }
    func toggle(habit: inout Habit, showDoneAlert: Bool) {
        
        @State var showDoneAlert = false
        /*
         The inout keyword is used to pass a parameter as a reference.
         This means that the parameter can be modified within the function
         and the changes will be reflected outside of the function.

         In your case, you are passing the habit parameter as an
         inout parameter to the toggle function, which means that
         any changes made to the habit variable within the function
         will be reflected outside of the function.
         */
       //---------------------------------------------------------------//
        
        
        // Check if the habit was already pressed today
//        if let lastPressDate = habit.lastPressDate,
//         Calendar.current.isDate(Date(), inSameDayAs: lastPressDate) {
//           print("Button already pressed today.")
//            return
//     }
        
        // Update the habit
        //habit.done = !habit.done
        if habit.days == 60 {
            showDoneAlert = true
        } else if habit.days <= habit.targetDays {
            habit.days += 1
        }
        // habit.lastPressDate = Date()
        
        // Save the habit to the database
        guard let user = auth.currentUser else { return }
        let habitsRef = db.collection("users").document(user.uid).collection("habits")
        if let id = habit.id {
            do {
                try habitsRef.document(id).setData(from: habit) { error in
                    if let error = error {
                        print("Error updating document: \(error.localizedDescription)")
                    } else {
                        print("Document successfully updated.")
                    }
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func saveHabit(habitName: String) {
        
        guard let user = auth.currentUser else {return}
        let habitsRef = db.collection("users").document(user.uid).collection("habits")
        let habit = Habit(name: habitName, days: 0)
        
        do {
            try habitsRef.addDocument(from: habit)
        }catch {
            print("Error saving to database")
        }
        
    }
    
    func listenToFirestore (){
        guard let user = auth.currentUser else {return}
        let habitsRef = db.collection("users").document(user.uid).collection("habits")
        
        
        habitsRef.addSnapshotListener() {
            snapshot, err in
            
            guard let snapshot = snapshot else {return}
            
            if let err = err {
                print("error getting document\(err)")
            } else {
                self.habits.removeAll()
                for document in snapshot.documents {
                    
                    do{
                        let habit = try document.data(as : Habit.self)
                        self.habits.append(habit)
                    } catch {
                        print("error reading from db")
                    }
                }
            }
        }
    }
}
