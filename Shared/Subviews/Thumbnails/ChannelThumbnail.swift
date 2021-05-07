//
//  ChannelThumbnail.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct ChannelThumbnail: View {
    
    @StateObject private var thumbnailLoader = ThumbnailLoader()
    private let width: CGFloat = macOS ? 50 : 60
    private let channel: Channel
    
    var body: some View {
        if let thumbnail = thumbnailLoader.thumbnail {
            thumbnail
                .resizable()
                .frame(width: width, height: width)
                .cornerRadius(width / 4)
        } else {
            Color.placeholder
                .frame(width: width, height: width)
                .cornerRadius(width / 4)
                .onAppear { thumbnailLoader.loadThumbnail(with: channel.maxSizeThumbnailUrl) }
                .onDisappear(perform: thumbnailLoader.cancel)
        }
    }
    
    init(_ channel: Channel) {
        self.channel = channel
    }
}
