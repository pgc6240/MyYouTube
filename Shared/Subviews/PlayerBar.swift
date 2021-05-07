//
//  PlayerBar.swift
//  MyYouTube (iOS)
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct PlayerBar: View {
    
    @EnvironmentObject private var player: YTPlayer
    @State private var currentTime: Float = 0
    @State private var editingStarted = false
    private let padding: CGFloat = 10
    
    var body: some View {
        if player.playingInBackground, let video = player.video {
            HStack {
                switch player.state {
                case .unstarted, .paused, .cued, .ended:
                    playButton
                case .playing:
                    pauseButton
                case .buffering:
                    loadingView
                }
                Spacer()
                VStack(alignment: .leading, spacing: .zero) {
                    Text(video.title).lineLimit(1)
                    if let duration = video._duration, duration > 0 {
                        playerBarSlider(with: duration)
                    }
                }
                Spacer()
                closeButton
            }
            .padding(padding)
            .frame(maxWidth: Screen.width, maxHeight: 65)
            .onReceive(player.$currentTime, perform: setCurrentTime)
            .background(BlurView())
        }
    }
}


// MARK: - Subviews -
private extension PlayerBar {
    
    var loadingView: some View {
        ProgressView()
            .scaleEffect(1.1)
            .padding(padding)
    }
    
    var playButton: some View {
        Button(action: play) {
            Image(systemName: Images.play)
        }.buttonStyle(PlayerBarButtonStyle(padding: padding))
    }
    
    var pauseButton: some View {
        Button(action: pause) {
            Image(systemName: Images.pause)
        }.buttonStyle(PlayerBarButtonStyle(padding: padding))
    }
    
    var closeButton: some View {
        Button(action: player.clear) {
            Image(systemName: Images.close)
        }.buttonStyle(PlayerBarButtonStyle(padding: padding))
    }
    
    func playerBarSlider(with duration: Float) -> some View {
        Slider(value: $currentTime,
               in: .zero...duration,
               onEditingChanged: seekTo,
               minimumValueLabel: Text(F.formatTime(currentTime)).kerning(1),
               maximumValueLabel: Text(F.formatTime(duration)).kerning(1),
               label: {})
    }
}


// MARK: - _ButtonStyle -
fileprivate struct PlayerBarButtonStyle: ButtonStyle {
    
    let padding: CGFloat
    
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(padding)
            .imageScale(.large)
            .contentShape(Rectangle())
            .foregroundColor(configuration.isPressed ? .accentColor : .primary)
            .background(
                Circle()
                    .strokeBorder(Color.accentColor.opacity(0.25), lineWidth: 2.5)
                    .background(Circle().fill(Color.secondary.opacity(0.1)))
                    .blur(radius: 1.5)
                    .scaleEffect(configuration.isPressed ? 1.2 : 0.01)
            )
    }
}


// MARK: - Internal methods -
private extension PlayerBar {
    
    func play() {
        player.state = .playing
        player.play()
    }
    
    
    func pause() {
        player.state = .paused
        player.pause()
    }
    
    
    func seekTo(_ editingStarted: Bool) {
        self.editingStarted = editingStarted
        guard !editingStarted else { return }
        player.seekTo(time: currentTime)
    }
    
    
    func setCurrentTime(_ currentTime: Float) {
        guard !editingStarted else { return }
        self.currentTime = currentTime
    }
}


// MARK: - .playerBar() view modifier -
extension View {
    
    func playerBar() -> some View {
        ZStack(alignment: .bottom) {
            self
            PlayerBar()
        }
    }
}
