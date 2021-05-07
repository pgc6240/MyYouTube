//
//  VideoStatistics.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct VideoStatistics: View {
    
    private let video: Video
    
    var body: some View {
        #if os(iOS)
        if video._viewCount >= 10_000 {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Label(video.likeCount, systemImage: Images.like)
                    Label(video.dislikeCount, systemImage: Images.dislike)
                    Label(video.commentCount, systemImage: Images.comments)
                }
                Text("\(video.viewCount) views")
                Text("\(video._publishedAt, formatter: F.df2)").italic()
            }
            .foregroundColor(.secondary)
            .font(Font.title3.weight(.light))
        } else {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    HStack {
                        Label(video.likeCount, systemImage: Images.like)
                        Label(video.dislikeCount, systemImage: Images.dislike)
                        Label(video.commentCount, systemImage: Images.comments)
                    }.layoutPriority(1)
                    Spacer(minLength: 5)
                    Text("\(video.viewCount) views")
                }
                Text("\(video._publishedAt, formatter: F.df2)").italic()
            }
            .lineLimit(1)
            .foregroundColor(.secondary)
            .font(Font.title3.weight(.light))
            .minimumScaleFactor(0.75)
        }
        #elseif os(macOS)
        HStack(spacing: 20) {
            Text("\(video._publishedAt, formatter: F.df2)").italic()
            HStack {
                Label(video.likeCount, systemImage: Images.like)
                Label(video.dislikeCount, systemImage: Images.dislike)
                Label(video.commentCount, systemImage: Images.comments)
            }.layoutPriority(1)
            Spacer()
            Text("\(video.viewCount) views")
        }
        .foregroundColor(.secondary)
        .font(Font.title3.weight(.light))
        #endif
    }
    
    init(_ video: Video) {
        self.video = video
    }
}
