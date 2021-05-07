//
//  ThumbnailLoader.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import Combine
import SwiftUI

class ThumbnailLoader: ObservableObject {
    
    @Published private(set) var thumbnail: Image?
    
    private var thumbnailURL: URL?
    private var cancellable:  AnyCancellable?

    
    deinit { cancel() }
    
    
    // MARK: - External methods -
    func loadThumbnail(with thumbnailUrl: String?) {
        guard let thumbnailURL = URL(thumbnailUrl) else { return }
        self.thumbnailURL      = thumbnailURL
        if let cachedThumbnail = cachedThumbnail {
            setThumbnail(cachedThumbnail)
            return
        }
        cancellable = URLSession.shared.dataTaskPublisher(for: thumbnailURL)
            .map(cacheImage)
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: setThumbnail)
    }
    
    
    func setThumbnail(_ thumbnail: Image?) {
        guard thumbnail != nil else { return }
        self.thumbnail   = thumbnail
    }
}


// MARK: - Cache -
private extension ThumbnailLoader {
    
    var cachedThumbnailURL: URL? {
        guard let thumbnailURL  = thumbnailURL, let cachesDirectory = FileManager.cachesDirectory else { return nil }
        let videoId             = thumbnailURL.deletingLastPathComponent().lastPathComponent
        let thumbnailResolution = thumbnailURL.lastPathComponent
        return cachesDirectory.appendingPathComponent(videoId).appendingPathExtension(thumbnailResolution)
    }
    
    var cachedThumbnail: Image? {
        guard let cachedThumbnailURL = cachedThumbnailURL else { return nil }
        return Image(contentsOfFile: cachedThumbnailURL.path)
    }
    
    
    func cacheImage(_ data: Data, _ response: URLResponse) -> Image? {
        if let cachedThumbnailURL = cachedThumbnailURL {
            try? data.write(to: cachedThumbnailURL)
        }
        return Image(data: data)
    }
}


// MARK: - Cancellable -
extension ThumbnailLoader: Cancellable {
    
    func cancel() {
        cancellable?.cancel()
        cancellable = nil
    }
}


// MARK: - AsyncThumbnailLoader -
final class AsyncThumbnailLoader: ThumbnailLoader {
    
    override func loadThumbnail(with thumbnailUrl: String?) {
        DispatchQueue.global(qos: .userInteractive).async {
            super.loadThumbnail(with: thumbnailUrl)
        }
    }
    
    
    override func setThumbnail(_ thumbnail: Image?) {
        DispatchQueue.main.async {
            super.setThumbnail(thumbnail)
        }
    }
}
