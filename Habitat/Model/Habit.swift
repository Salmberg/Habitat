//
//  Habit.swift
//  Habitat
//
//  Created by David Salmberg on 2023-04-19.
//

import Foundation
import FirebaseFirestoreSwift


struct Habit : Codable, Identifiable {
    @DocumentID var id : String?
    var name : String
    var days : Int = 0
    var done : Bool = false
    var isCompleted : Bool = false
   // var lastPressDate: Date?
   // var procent : Float
    

}


