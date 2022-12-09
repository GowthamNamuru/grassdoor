//
//  ImageDownloader.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import Combine
import UIKit.UIImage

final class ImageDownloader: ObservableObject {
    @Published var image: UIImage?
    
    private(set) var isLoading = false
    
    private let url: URL
    private var cancellable: AnyCancellable?
    private var cache: ImageCache?
    
    
    private static let imageQueue = DispatchQueue(label: "imageDownloader")
    
    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    
    func load() {
        guard !isLoading else {
            return
        }
        if let image = cache?[url] {
            self.image = image
            return
        }
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map{ UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(
                receiveSubscription: { [weak self] _ in self?.onStart() },
                receiveOutput: { [weak self] in self?.updateCache($0) },
                receiveCompletion: { [weak self] _ in self?.onFinish() },
                receiveCancel: { [weak self] in self?.onFinish() })
            .subscribe(on: Self.imageQueue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }
    
    
    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
    
    private func updateCache(_ tempImage: UIImage?) {
        cache?[url] = tempImage
    }
    
    deinit {
        cancellable?.cancel()
    }
    
}
