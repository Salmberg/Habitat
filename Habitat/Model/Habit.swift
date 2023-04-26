//
//  Habit.swift
//  Habitat
//
//  Created by David Salmberg on 2023-04-19.
//

import Foundation
import FirebaseFirestoreSwift


struct Habit : Codable, Identifiable, Equatable {
    @DocumentID var id : String?
    var name : String
    var days : Int = 0
   // var done : Bool = false
    var isCompleted : Bool = false
    var targetDays: Int = 60
    var procent : Float {
            return min(Float(self.days) / 21.0, 1.0)
        }
   // var lastPressDate : Date?

}


