//
//  ProgressBarView.swift
//  Habitat
//
//  Created by David Salmberg on 2023-04-27.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift
import Firebase
import FirebaseFirestore

struct ProgressBar: View {
    let habit : Habit
    @Binding var progress: Float

    func updateProgress() {
            let habitProgress = Float(habit.days) == 0 ? 0.0 : Float(habit.progressValue) / 60
            self.progress = habitProgress
            
        }
    
    
    var body: some View {
        
        
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.green)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.green)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            Text(habit.name)
                .padding(.bottom, 50)
                .bold()
        
//            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
//                .font(.largeTitle)
//                .bold()
            Text("Dagar:\(habit.days)")
                .padding(.top, 50)
        }
        .onAppear{
            updateProgress()
        }
    }
}
