//
//  HabitsVM.swift
//  Habitat
//
//  Created by David Salmberg on 2023-04-20.
//

import Foundation
import Firebase

class HabitsVM : ObservableObject {
    let db = Firestore.firestore()
    let auth = Auth.auth()

    
    @Published var habits = [Habit]()
    
    func delete(index: Int) {
        guard let user = auth.currentUser else {return}
        let habitsRef = db.collection("users").document(user.uid).collection("habits")
        
        let habit = habits[index]
        if let id = habit.id {
            habitsRef.document(id).delete()
        }
    }
    
    func toggle(habit: inout Habit) {
        /*
         passing the habit parameter as an "inout" parameter
         to the toggle function, which means that any changes
         made to the habit variable within the function will
         be reflected outside of the function.
        */
        guard let user = auth.currentUser else { return }
        let habitsRef = db.collection("users").document(user.uid).collection("habits")
        
        if let id = habit.id {
            habitsRef.document(id).updateData(["done": !habit.done])
            
            habit.days += 1
            habitsRef.document(id).updateData(["days": habit.days]) { error in
                if let error = error {
                    print("Error updating document: \(error.localizedDescription)")
                } else {
                    print("Document successfully updated.")
                }
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
