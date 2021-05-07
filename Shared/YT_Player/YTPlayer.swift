//
//  YTPlayer.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import WebKit

final class YTPlayer: NSObject, ObservableObject {
    
    /// Player's main view.
    var webView: WKWebView?
    
    /// Player's state.
    @Published var state = YTPlayerState.unstarted
    var playingInBackground = false
    var ready = false
    
    /// Player's current time.
    @Published var currentTime: Float = 0
    weak var timer: Timer?
    
    /// Current player's video.
    weak var video: Video?
}
    
 
// MARK: - External methods -
extension YTPlayer {
    
    func loadVideo(_ video: Video) {
        guard webView?.url == nil,
              let path       = Bundle(for: Self.self).path(forResource: String(describing: Self.self), ofType: "html"),
              var htmlString = try? String(contentsOfFile: path) else { return }
        self.video = video
        htmlString = htmlString.replacingOccurrences(of: "%@", with: video.id)
        webView?.loadHTMLString(htmlString, baseURL: nil)
    }
    
    
    func clear() {
        stop()
        webView = nil
        ready = false
        state = .unstarted
        playingInBackground = false
        currentTime = 0
        timer?.invalidate()
        timer = nil
        video = nil
    }

    
    func playInBackground(at time: Float? = nil) {
        playingInBackground = true
        var flag = true
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [self] timer in
            guard playingInBackground else {
                timer.invalidate()
                return
            }
            switch state {
            case .unstarted, .buffering:
                play()
            case .playing:
                play()
                if flag, let time = time, time > 0 {
                    flag = false
                    currentTime = time
                    seekTo(time: time)
                }
            case .paused:
                pause()
            case .cued, .ended:
                playingInBackground = false
            }
        }
    }
    
    
    func setTimeStamp() {
        guard playingInBackground, let video = video else { return }
        TimeStampManager.shared.setTimeStamp(videoId: video.id, time: currentTime)
    }
}
