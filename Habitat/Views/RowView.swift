//
//  RowView.swift
//  Habitat
//
//  Created by David Salmberg on 2023-04-27.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift
import Firebase



struct RowView: View {
    @State var progressValue: Float = 0.0
    @State var showDoneAlert = false
    @State var habit: Habit
    let vm: HabitsVM
    
    var body: some View {
        HStack {
            ProgressBar(habit: habit, progress: self.$progressValue)
                .frame(width: 150.0, height: 150.0)
                .padding(20.0)
                .padding(.leading, 105)
            Spacer()
            Button(action: {
                vm.toggle(habit: &habit, showDoneAlert: $showDoneAlert)
            }) {
                // Checkmark?
            }
            Button(action: {
                guard let index = vm.habits.firstIndex(where: { $0.id == habit.id }) else { return }
                vm.delete(index: index)
            }) {
                Image(systemName: "trash")
            }
            .padding()
        }
        Button(action: {
            vm.toggle(habit: &habit, showDoneAlert: $showDoneAlert)
            self.incrementProgress()
            if habit.days == habit.targetDays {
                print("Congratulations! You have completed your habit for 60 days.")
                showDoneAlert = true
            } else if habit.days <= habit.targetDays {
                print("Adding days")
                habit.days += 1
            }
        }) {
                Text("Utför")
                    .foregroundColor(.white)
            
            
            .padding(15.0)
            .overlay(
                RoundedRectangle(cornerRadius: 15.0)
                    .stroke(lineWidth: 2.0)
                    .foregroundColor(.white)
            )
            
        }
        .alert(isPresented: $showDoneAlert) {
            Alert(title: Text("Congratulations!"), message: Text("You have completed your habit for 60 days."), primaryButton: .default(Text("OK")), secondaryButton: .destructive(Text("Add a new Habit")) {
                
            })
        }
    }
    
    func incrementProgress() {
        let randomValue = Float([0.012, 0.022, 0.034, 0.016, 0.11].randomElement()!)
        self.progressValue += randomValue
    }
    
  
}
