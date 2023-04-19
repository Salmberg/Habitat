//
//  ContentView.swift
//  Habitat
//
//  Created by David Salmberg on 2023-04-19.
//

import SwiftUI
import Firebase


struct ContentView: View {
    
    var body: some View {
        let db = Firestore.firestore()
        
        
        VStack {
            Text("Habitat")
                .font(.largeTitle)
                .bold()
            Text("The way to make new habits")
                .font(.title)
            
            Spacer()
            
            Text("Sign in to make your new habits")
           
            Spacer()
        }.onAppear() {
            db.collection("Test").addDocument(data: ["name": "David"])
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
