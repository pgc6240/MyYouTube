//
//  VideoListRow.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct VideoListRow: View {
    
    private let video: Video
    private let videoList: VideoList
    
    var body: some View {
        HStack {
            VideoThumbnail(video, thumbnailSize: .small)
            VStack(alignment: .leading) {
                Text(video.title).lineLimit(3)
                VStack(alignment: .leading) {
                    switch videoList {
                    case .mostPopular:
                        Text("\(video.viewCount) views")
                    case .videosSearch:
                        Text(video.channelTitle)
                        Text(video.publishedAt)
                        Text("\(video.viewCount) views").if(video._duration == nil) { $0.redacted(reason: .placeholder) }
                    case .myTimeStamps:
                        Text(video.channelTitle)
                        Text("Time stamp at: \(F.formatTime(video.timeStamp?.time))")
                    case .channelVideos:
                        Text(video.publishedAt)
                        Text("\(video.viewCount) views").if(video._duration == nil) { $0.redacted(reason: .placeholder) }
                    }
                }
                .foregroundColor(.secondary)
                .font(.callout)
                .lineLimit(1)
            }
        }
    }
    
    init(_ video: Video, videoList: VideoList) {
        self.video     = video
        self.videoList = videoList
    }
}


// MARK: - VideoList -
enum VideoList {
    case mostPopular
    case videosSearch
    case myTimeStamps
    case channelVideos
}
