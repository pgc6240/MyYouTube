//
//  ChannelVideos.swift
//  MyYouTube (iOS)
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct ChannelVideos: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var videoLoader = ChannelVideosVL()
    @State private var filterQuery = ""
    private let channel: Channel
    
    var body: some View {
        List {
            PageControl(delegate: self, dataSource: videoLoader)
            SearchField("Search on current page...", query: $filterQuery)
            if videoLoader.isLoading {
                ProgressView()
            } else if videoLoader.videos.filter(filterMethod).isEmpty {
                EmptyStateView(filterQuery.isEmpty ? "No channel videos." : "No videos matching query.")
            } else {
                ForEach(videoLoader.videos.lazy.sorted { $0._publishedAt > $1._publishedAt }.filter(filterMethod)) { video in
                    NavigationLink(destination: PlayerView(video).navigationBarHidden(true)) {
                        VideoListRow(video, videoList: .channelVideos)
                    }
                }
            }
        }
        .onReceive(videoLoader.initialized, perform: getChannelVideos)
        .navigationTitle("\(channel.title)'s videos")
    }
    
    init(_ channel: Channel) {
        self.channel = channel
    }
}


// MARK: - Internal methods -
private extension ChannelVideos {
    
    func getChannelVideos() {
        videoLoader.getPlaylistItems(playlistId: channel.uploads)
    }
    
    
    func filterMethod(_ video: Video) -> Bool {
        guard !filterQuery.isEmpty else { return true }
        return video.title.lowercased().contains(filterQuery.lowercased())
    }
}


// MARK: - PageControlDelegate -
extension ChannelVideos: PageControlDelegate {
    
    func goToPage(with pageToken: String) {
        videoLoader.getPlaylistItems(playlistId: channel.uploads, pageToken: pageToken)
    }
}
