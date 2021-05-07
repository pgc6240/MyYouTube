//
//  VideoFeed.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct VideoFeed: View {
    
    @EnvironmentObject private var myYouTube: MyYouTube
    @StateObject private var videoLoader = VideoFeedLoader()
    
    var body: some View {
        VStack {
            if videoLoader.isLoading {
                LoadingView()
            } else {
                ScrollView(showsIndicators: false) {
                    sharedVideo
                    if videoLoader.videos.isEmpty {
                        EmptyStateView("There will be subscribed channel videos.\nPlease, subscribe for one.").padding()
                    } else {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 330), spacing: 10)], spacing: 5) {
                            ForEach(videoLoader.videos.sorted { $0._publishedAt > $1._publishedAt }) { video in
                                videoCell(video).onAppear {
                                    videoLoader.getNextPage(currentlyDisplaying: video)
                                }
                            }
                        }
                        .padding(macOS ? 10 : 0)
                        .offset(y: iOS ? -8 : 0)
                    }
                }
            }
        }
        .onReceive(videoLoader.initialized, perform: videoLoader.setVideoFeed)
        .onReceive(SubscriptionManager.publisher, perform: videoLoader.updateVideoFeed)
    }
}


// MARK: - Subviews -
private extension VideoFeed {
    
    var sharedVideo: some View {
        #if os(iOS)
        return SharedVideoView()
        #elseif os(macOS)
        return EmptyView()
        #endif
    }
    
    func videoCell(_ video: Video) -> some View {
        #if os(iOS)
        return NavigationLink(destination: PlayerView(video).navigationBarHidden(true)) {
            VideoCell(video)
        }
        #elseif os(macOS)
        return VideoCell(video).onTapGesture {
            myYouTube.selectedVideo = video
        }
        #endif
    }
}
