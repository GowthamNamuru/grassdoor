//
//  ContentView.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Group {
                HomeTab()
            }
            .navigationBarTitle("Movies", displayMode: .automatic)
        }
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
