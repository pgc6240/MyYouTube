//
//  VideoDuration.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct VideoDuration: View {
    
    private let video: Video
    private let thumbnailSize: ThumbnailSize
    
    var body: some View {
        if let duration = video.duration, duration != "00:00" {
            Text(duration)
                .if(duration == "LIVE") {
                    $0.foregroundColor(Color.accentColor.opacity(0.9))
                }
                .if(duration == "LIVE") {
                    $0.font(Font.footnote.bold())
                }
                .if(thumbnailSize == .small) {
                    $0.font(.footnote)
                }
                .if(thumbnailSize != .small) {
                    $0.font(.callout)
                }
                .foregroundColor(Color.white.opacity(0.9))
                .padding(6)
                .background(Color.black.opacity(0.7))
                .cornerRadius(8)
                .padding(6)
        }
    }
    
    init(_ video: Video, thumbnailSize: ThumbnailSize = .medium) {
        self.video         = video
        self.thumbnailSize = thumbnailSize
    }
}
