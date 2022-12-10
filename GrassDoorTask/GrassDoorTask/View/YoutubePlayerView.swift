//
//  YoutubePlayerView.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 10/12/22.
//

import SwiftUI
import WebKit

struct VideoPlayer: View {
    var trailer: Trailers
    var body: some View {
        YouTubeView(videoTrailer: trailer)
            .frame(minHeight: 0, maxHeight: UIScreen.main.bounds.height * 0.3)
            .cornerRadius(12)
            .padding(.horizontal, 24)
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
