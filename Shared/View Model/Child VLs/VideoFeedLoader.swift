//
//  VideoFeedLoader.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

final class VideoFeedLoader: VideoLoader {
    
    
    func setVideoFeed() {
        guard !SubscriptionManager.playlistIds.isEmpty else {
            setLoading(false)
            return
        }
        withAnimation(iOS ? .default : nil) {
            SubscriptionManager.playlistIds.forEach {
                getPlaylistItems(playlistId: $0)
            }
        }
    }
    
    
    func getNextPage(currentlyDisplaying video: Video) {
        guard let index = indices[video.id] else { return }
        let updateRange = (videos.endIndex - SubscriptionManager.playlistIds.count * 50 ... videos.endIndex)
        if updateRange.contains(index) {
            for playlistId in SubscriptionManager.playlistIds {
                guard let nextPageToken = pageInfos[playlistId]?.nextPageToken else { continue }
                getPlaylistItems(playlistId: playlistId, pageToken: nextPageToken)
            }
        }
    }
    
    
    func updateVideoFeed() {
        cancel()
        setLoading()
        emptyVideos()
        setVideoFeed()
    }
}
