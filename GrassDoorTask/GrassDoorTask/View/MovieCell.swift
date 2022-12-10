//
//  MovieCell.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 10/12/22.
//

import SwiftUI

struct MovieCell: View {
    
    var movie: MovieViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            moviePoster
            
            VStack(alignment: .leading, spacing: 0) {
                movieTitle
                
                HStack {
                    votingView
                    
                    Text(movie.releaseDate)
                        .foregroundColor(.black)
                        .font(.subheadline)
                }
            }

        }
    }
    
    private var moviePoster: some View {
        AsyncImage(imageName: movie.imageName, url: URL(string: movie.posterPath)!) {
            Rectangle().foregroundColor(Color.gray.opacity(0.4))
        } image: { image in
            Image(uiImage: image)
                .resizable()
        }
        .frame(width: 100, height: 160)
        .animation(.easeInOut(duration: 0.5))
        .transition(.opacity)
        .scaledToFill()
        .cornerRadius(15)
        .shadow(radius: 15)
    }
    
    
    private var movieTitle: some View {
        Text(movie.title)
            .font(.title)
            .bold()
            .foregroundColor(.blue)
    }
    
    
    private var votingView: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: CGFloat(movie.votingAverage))
                .stroke(.orange, lineWidth: 4)
                .frame(width: 50)
                .rotationEffect(.degrees(-90))
            
            Circle()
                .trim(from: 0, to: 1)
                .stroke(.orange.opacity(0.2), lineWidth: 4)
                .frame(width: 50)
                .rotationEffect(.degrees(-90))
            Text(String.init(format: "%0.2f", movie.movie.voteAverage ?? 0.0))
                .foregroundColor(.orange)
                .font(.subheadline)
        }.frame(height: 80)
    }
}

