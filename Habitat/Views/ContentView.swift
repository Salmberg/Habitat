//
//  ContentView.swift
//  Habitat
//
//  Created by David Salmberg on 2023-04-19.
//

import SwiftUI
import FirebaseFirestoreSwift
import Firebase



struct ContentView : View {
    @StateObject var authVM = AuthViewModel()
    
    @State var signedIn = false
    
    var body: some View {
        if !signedIn {
            SignInView(signedIn: $signedIn, authVM: authVM)
        } else {
            HabitListView(authVM: authVM)
        }
    }
}


struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }
}




