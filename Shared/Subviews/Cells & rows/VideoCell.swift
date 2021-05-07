//
//  VideoCell.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct VideoCell: View {
    
    private let video: Video
    private let spacing: CGFloat = 5
    
    var body: some View {
        VStack(spacing: spacing) {
            VideoThumbnail(video, thumbnailSize: .medium)
            VStack(alignment: .leading, spacing: spacing) {
                Text(video.title).foregroundColor(.primary)
                HStack {
                    Text(video.channelTitle)
                    Spacer()
                    Text(video.publishedAt)
                }.foregroundColor(.secondary)
            }
            .lineLimit(1)
            .padding(.horizontal, spacing)
        }
    }
    
    init(_ video: Video) {
        self.video = video
    }
}
