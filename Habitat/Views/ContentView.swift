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
    let auth = Auth.auth()
    
    @State var signedIn = false
    
    var body: some View {
            if !signedIn {
                SignInView(signedIn: $signedIn, authVM: authVM)
            } else {
                HabitListView(authVM: authVM, signedIn: $signedIn) // Pass the signedIn binding to the HabitListView
            }
        }

}



struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }
}




