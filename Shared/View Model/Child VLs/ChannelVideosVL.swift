//
//  ChannelVideosVL.swift
//  MyYouTube (iOS)
//
//  Created by pgc6240 on 07.05.2021.
//

final class ChannelVideosVL: VideoLoader {
    
    
    override func getPlaylistItems(playlistId: String?, pageToken: String? = nil) {
        guard let playlistId = playlistId else { return }
        cancel()
        setLoading()
        emptyVideos()
        super.getPlaylistItems(playlistId: playlistId, pageToken: pageToken)
    }
}
