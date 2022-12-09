//
//  Main.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import SwiftUI

struct Main: View {
    var body: some View {
        TabView {
            ContentView(title: "Popular")
                .tabItem {
                    Label("Popular", systemImage: "list.star")
                }
            
            ContentView(title: "Top Rated")
                .tabItem {
                    Label("Top Rated", systemImage: "list.number")
                }
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
