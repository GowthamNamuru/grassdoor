//
//  MoviesView.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 10/12/22.
//

import SwiftUI

struct MoviesView: View {
    @ObservedObject var movieManager = MovieServiceDownloader()
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().selectionStyle = .none
        
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = .orange
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.orange]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.orange]
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(movieManager.movies) { movie in
                    NavigationLink(destination: Text(movie.title)) {
                        Text(movie.title)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .onAppear{
                movieManager.getPopular()
            }
            
            Spacer()
        }
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
    }
}
