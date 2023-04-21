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
    var days : Int
    var done : Bool = false
    
   

}
