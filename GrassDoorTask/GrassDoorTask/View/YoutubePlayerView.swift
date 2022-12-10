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
    private var url: URL {
        return URL(string: "https://www.youtube.com/embed/\(videoTrailer.key)")!
    }
    let videoTrailer: Trailers
    func makeUIView(context: Context) ->  WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}
