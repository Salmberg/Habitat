//
//  ContentView.swift
//  Habitat
//
//  Created by David Salmberg on 2023-04-19.
//

import SwiftUI
import FirebaseFirestoreSwift
import Firebase


struct ContentView: View {
    @State var progressValue: Float = 0.0
    
    let db = Firestore.firestore()
    
    @State var habits = [Habit]()
    
    var body: some View {
        
    
        
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            
            
            
            Spacer()
            VStack {
                ScrollView{
                   
                    Text("Hej").foregroundColor(.white)
                    
                    ForEach(habits) { habit in
                        Text(habit.name)
                            .foregroundColor(.white)
                    }
                    
                    ProgressBar(progress: self.$progressValue)
                        .frame(width: 150.0, height: 150.0)
                        .padding(40.0)
                        .foregroundColor(.white)
                    
                    Button(action: {
                        self.incrementProgress()
                    }) {
                        HStack {
                            Text("Utför")
                        }
                        .padding(15.0)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15.0)
                                .stroke(lineWidth: 2.0)
                                .foregroundColor(.white)
                        )
                    }
                    
                }
                
            }
        }
        
        }
    func incrementProgress() {
            let randomValue = Float([0.012, 0.022, 0.034, 0.016, 0.11].randomElement()!)
            self.progressValue += randomValue
        }
    
    struct ProgressBar: View {
        @Binding var progress: Float
        
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

                Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                    .font(.largeTitle)
                    .bold()
            }
        }
    }

    
    
    
    func saveHabit(habitName: String) {
        let habit = Habit(name: habitName, days: 0)
        
        do {
            try db.collection("habits").addDocument(from: habit)
        }catch {
            print("Error saving to database")
        }
        
    }
    
    func listenToFirestore (){
        db.collection("habits").addSnapshotListener() {
            snapshot, err in
            
            guard let snapshot = snapshot else {return}
            
            if let err = err {
                print("error getting document\(err)")
            } else {
                habits.removeAll()
                for document in snapshot.documents {
                    
                    do{
                        let habit = try document.data(as : Habit.self)
                        habits.append(habit)
                    } catch {
                        print("error reading from db")
                    }
                }
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
