//
//  ContentView.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var title: String
    
    var body: some View {
        Text(title)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(title: "Some title")
    }
}
