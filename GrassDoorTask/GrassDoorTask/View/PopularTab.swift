//
//  PopularTab.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import SwiftUI

struct PopularTab: View {
    var body: some View {
        MoviesView(selectedTab: .popular)
    }
}

struct PopularTab_Previews: PreviewProvider {
    static var previews: some View {
        PopularTab()
    }
}
