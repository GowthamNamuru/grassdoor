//
//  AsyncImage.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 10/12/22.
//

import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageDownloader
    private let placeholder: Placeholder
    private let image: (UIImage) -> Image
    
    
    init(imageName: String,
         url: URL,
         @ViewBuilder placeholder: () -> Placeholder,
         @ViewBuilder  image: @escaping (UIImage) -> Image = Image.init(uiImage:)) {
        self.placeholder = placeholder()
        self.image = image
        _loader = StateObject(wrappedValue: ImageDownloader(imageName: imageName, url: url, cache: Environment(\.imageCache).wrappedValue))
    }
    
    var body: some View {
        content.onAppear(perform: loader.load)
    }
    
    private var content: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
            } else {
                placeholder
            }
        }
    }
}
