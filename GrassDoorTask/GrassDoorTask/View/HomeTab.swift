//
//  HomeTab.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import SwiftUI

struct HomeTab: View {
    
    enum Tab: Int {
        case popular
        case topRated
    }
    
    @State private var selectedTab = Tab.popular
    
    var body: some View {
        TabView(selection: $selectedTab) {
            PopularTab().tabItem {
                tabBarItem(imageName: "film", title: "Popular")
            }
            .tag(Tab.popular)
            
            TopRated().tabItem {
                tabBarItem(imageName: "film", title: "Top Rated")
            }
            .tag(Tab.topRated)
        }
    }
    
    private func tabBarItem(imageName: String, title: String) -> some View {
        VStack {
            Image(systemName: imageName)
                .imageScale(.large)
            
            Text(title)
        }
    }
}

struct HomeTab_Previews: PreviewProvider {
    static var previews: some View {
        HomeTab()
    }
}
