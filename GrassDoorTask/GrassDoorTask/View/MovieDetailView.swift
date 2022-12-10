//
//  MovieDetailView.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 10/12/22.
//

import SwiftUI
import WebKit

struct MovieDetailView: View {
    
    @StateObject private var loader: ImageDownloader
    @ObservedObject private var movieService: MovieServiceDownloader
    @State private var userReview: String = ""
    @ObservedObject private var codableStore: CodableReviewStore
    
    @State private var presentAlert = false
    
    var movieViewModel: MovieViewModel
    
    init(movie: MovieViewModel) {
        movieViewModel = movie
        let url = URL(string: movieViewModel.posterPath)!
        let imageName = movieViewModel.imageName
        _loader = StateObject(wrappedValue: ImageDownloader(imageName: imageName, url: url))
        movieService = MovieServiceDownloader(type: .movieTrailers(id: movieViewModel.id))
        codableStore = CodableReviewStore(movieId: "\(movie.id)")
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            backgroundView
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    headerView
                    moviePosterView
                    movieOverview
                    addReview
                }
                .padding(.top, 84)
                .padding(.horizontal, 32)
            }
        }
        .onAppear {
            movieService.getMovies()
            codableStore.retrieveReview()
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private var backgroundView: some View {
        imageView.onAppear{
            loader.load()
        }
        .blur(radius: 100)
    }
    
    private var imageView: some View {
        Group {
            if let loadedImage = loader.image {
                Image(uiImage: loadedImage)
                    .resizable()
            } else {
                Rectangle().foregroundColor(Color.gray.opacity(0.4))
            }
        }
    }
    
    
    private var headerView: some View {
        VStack(alignment: .leading) {
            Text(movieViewModel.title)
                .font(.title)
            
            Text("Release Date: \(movieViewModel.releaseDate)")
                .font(.subheadline)
        }
        .foregroundColor(.white)
    }
    
    private var moviePosterView: some View {
        HStack(alignment: .center) {
            Spacer()
            imageView
                .frame(width: 200, height: 320)
                .cornerRadius(20)
            Spacer()
        }
    }
    
    private var movieOverview: some View {
        Text(movieViewModel.movie.overview)
            .font(.body)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, 16)
    }
    
//    private var trailersView: some View {
//        ZStack {
//            ScrollView(showsIndicators: false) {
//                VStack {
//                    Text("Trailers")
//                        .font(.title)
//                    List {
//                        ForEach(movieService.trailers) { trailer in
//                            NavigationLink {
////                                YouTubeView(videoTrailer: trailer)
////                                    .frame(width: 300, height: 300)
////                                    .padding()
//                            } label: {
//                                Text(trailer.name)
//                                    .padding()
//                                    .font(.caption)
//                            }
//                        }
//                    }
//                }
//            }
//
//        }
//    }
    
    private var addReview: some View {
        VStack {
            Spacer()
            Text(codableStore.review.reviews)
                .font(.subheadline)
                .fontWeight(.bold)
                .backgroundStyle(Color.white)
            
            Spacer()
            Button("Have you watched movie") {
                presentAlert = true
            }
            .alert("Update your review", isPresented: $presentAlert, actions: {
                TextField("Review", text: $userReview)
                Button("Add Review", role: .destructive, action: {
                    
                    codableStore.insert(Review(id: "\(movieViewModel.id)", reviews: userReview)) { error in
                        
                    }
                    
                    codableStore.retrieveReview()
                })
                
                Button("Ok", role: .cancel, action: {
                    
                })
            }, message: {
                Text("Add review.")
            })
            
        }
    }
    
}

struct YouTubeView: UIViewRepresentable {
    let videoTrailer: Trailers
    func makeUIView(context: Context) ->  WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let demoURL = URL(string: "https://www.youtube.com/embed/\(videoTrailer.key)") else { return }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: demoURL))
    }
}
