//
//  PlayerView.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct PlayerView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var videoPlayer: YTPlayer
    @EnvironmentObject private var myYouTube: MyYouTube
    @StateObject private var channelLoader = ChannelLoader()
    @State private var currentTime: Float = 0
    @State private var timeStamp: Float?
    private let video: Video
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                VideoThumbnail(video, thumbnailSize: .large).padding(.horizontal, -1)
                if !videoPlayer.playingInBackground {
                    videoPlayer
                }
            }
            .aspectRatio(CGSize(width: 16, height: 9), contentMode: iOS ? .fit : .fill)
            .overlay(closeButton, alignment: .topLeading)
            .overlay(playInBackgroundButton, alignment: .topTrailing)
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    videoTitle
                    timeStampControls
                    VideoStatistics(video)
                    if let channel = channelLoader.videos.first {
                        ChannelListRow(channel)
                    }
                    VideoDescription(video)
                }.padding(.horizontal, 10)
            }
        }
        .onAppear(perform: setPlayerView)
        .onReceive(videoPlayer.$currentTime, perform: setCurrentTime)
        .hideNavigationBar()
    }
    
    init(_ video: Video) {
        self.video = video
    }
}


// MARK: - Subviews -
private extension PlayerView {
    
    var closeButton: some View {
        PlayerButton(imageName: iOS ? "chevron.left" : "xmark").onTapGesture(perform: close)
    }
    
    var playInBackgroundButton: some View {
        #if os(iOS)
        return PlayerButton(imageName: "speaker.wave.2.fill")
            .onTapGesture(perform: playVideoInBackground)
            .opacity(videoPlayer.playingInBackground ? 0 : 1)
        #elseif os(macOS)
        return EmptyView()
        #endif
    }
    
    var videoTitle: some View {
        Text(video.title)
            .font(macOS ? .title : .title2)
            .lineLimit(macOS ? 1 : nil)
            .help(video.title)
    }
    
    var timeStampControls: some View {
        HStack(spacing: 10) {
            Button("Set time stamp at:\n\(F.formatTime(currentTime))", action: setTimeStamp)
            Button("Play at time stamp:\n\(F.formatTime(timeStamp))", action: playAt)
        }.buttonStyle(TimeStampButtonStyle())
    }
}


// MARK: - Methods -
private extension PlayerView {
    
    func setPlayerView() {
        videoPlayer.loadVideo(video)
        channelLoader.get(.channels, with: [video.channelId])
        timeStamp = TimeStampManager.shared.getTimeStamp(with: video.id)?.time
    }
    
    
    func setCurrentTime(_ currentTime: Float) {
        guard video.id == videoPlayer.video?.id else { return }
        self.currentTime = currentTime
    }
    
    
    func setTimeStamp() {
        timeStamp = videoPlayer.currentTime
        TimeStampManager.shared.setTimeStamp(videoId: video.id, time: videoPlayer.currentTime)
    }
    
    
    func playAt() {
        videoPlayer.seekTo(time: timeStamp ?? currentTime)
    }
    
    
    func playVideoInBackground() {
        presentationMode.wrappedValue.dismiss()
        videoPlayer.playInBackground(at: currentTime == 0 ? timeStamp : currentTime)
    }
    
    
    func close() {
        myYouTube.selectedVideo = nil
        presentationMode.wrappedValue.dismiss()
    }
}


// MARK: - Time stamp controls style -
fileprivate struct TimeStampButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label.font(iOS ? .callout : .body)
            Spacer()
        }
        .padding(.vertical, 5)
        .foregroundColor(.primary)
        .background(configuration.isPressed ? Color.red : Color.gray.opacity(0.5))
        .cornerRadius(5)
    }
}
