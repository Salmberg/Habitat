//
//  AuthViewModel.swift
//  Habitat
//
//  Created by David Salmberg on 2023-04-20.
//

import Foundation
import Firebase

class AuthState: ObservableObject {
    @Published var isSignedIn = false
}

class AuthViewModel : ObservableObject{
    
    func scheduleDailyNotification(hour: Int, minute: Int, identifier: String, title: String, body: String) {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default

            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

            center.add(request) { error in
                if error != nil {
                    print("Error scheduling notification: (error.localizedDescription)")
                }
            }
        }



    
    // Sign out
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
}
