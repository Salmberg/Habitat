//
//  HabitatApp.swift
//  Habitat
//
//  Created by David Salmberg on 2023-04-19.
//

import SwiftUI

import SwiftUI
import FirebaseCore
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
      let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if error != nil {
                    print("Error requesting notification authorization: (error.localizedDescription)")
                }
            }
    FirebaseApp.configure()
    return true
  }
}

@main
struct HabitatApp: App {
    @StateObject var authState = AuthState()
   

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authState)
        }
    }
}
