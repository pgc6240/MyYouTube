//
//  VideoThumbnail.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct VideoThumbnail: View {
    
    @StateObject private var thumbnailLoader: ThumbnailLoader
    private let thumbnailSize: ThumbnailSize
    private let video: Video
    
    var body: some View {
        if let thumbnail = thumbnailLoader.thumbnail {
            switch thumbnailSize {
            case .small:
                thumbnail
                    .resizable()
                    .scaledToFit()
                    .frame(width: 112, height: 86)
                    .cornerRadius(10)
                    .overlay(VideoDuration(video, thumbnailSize: .small).animation(.easeIn), alignment: .bottomTrailing)
            case .medium:
                thumbnail
                    .resizable()
                    .scaledToFill()
                    .frame(height: iOS ? 210 : 195)
                    .clipped()
                    .overlay(VideoDuration(video).animation(iOS ? .easeIn : nil), alignment: .bottomTrailing)
            case .large:
                thumbnail
                    .resizable()
                    .scaledToFill()
                    .frame(height: macOS ? 405 : 210)
                    .clipped()
            }
        } else {
            switch thumbnailSize {
            case .small:
                Color.placeholder
                    .frame(width: 112, height: 86)
                    .cornerRadius(10)
                    .overlay(VideoDuration(video, thumbnailSize: .small).animation(.easeIn), alignment: .bottomTrailing)
                    .onAppear { thumbnailLoader.loadThumbnail(with: video.highSizeThumbnailUrl) }
                    .onDisappear(perform: thumbnailLoader.cancel)
            case .medium:
                Color.placeholder
                    .frame(height: iOS ? 210 : 195)
                    .overlay(VideoDuration(video).animation(iOS ? .easeIn : nil), alignment: .bottomTrailing)
                    .onAppear { thumbnailLoader.loadThumbnail(with: video.maxSizeThumbnailUrl) }
                    .onDisappear(perform: thumbnailLoader.cancel)
            case .large:
                Color.placeholder
                    .frame(height: macOS ? 405 : 210)
                    .onAppear { thumbnailLoader.loadThumbnail(with: video.maxSizeThumbnailUrl) }
                    .onDisappear(perform: thumbnailLoader.cancel)
            }
        }
    }
    
    init(_ video: Video, thumbnailSize: ThumbnailSize) {
        self.video         = video
        self.thumbnailSize = thumbnailSize
        switch thumbnailSize {
        case .small: self._thumbnailLoader = StateObject(wrappedValue: ThumbnailLoader())
        default:     self._thumbnailLoader = StateObject(wrappedValue: AsyncThumbnailLoader())
        }
    }
}


// MARK: - ThumbnailSize -
enum ThumbnailSize {
    case small, medium, large
}
