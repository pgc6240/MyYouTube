//
//  YTPlayer+Event.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import WebKit
 
extension YTPlayer: WKNavigationDelegate {
    
    enum YTPlayerEvent: String {
        case onReady
        case onStateChange
    }

    
    enum YTPlayerState: String {
        case unstarted  = "-1"
        case ended      = "0"
        case playing    = "1"
        case paused     = "2"
        case buffering  = "3"
        case cued       = "5"
    }
    
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        decisionHandler(.allow)
        
        guard let url = navigationAction.request.url, url.scheme == "ytplayer",
              let eventRawValue = url.host,
              let event         = YTPlayerEvent(rawValue: eventRawValue) else { return }
        
        switch event {
        case .onReady:
            onReady()
        case .onStateChange:
            guard let stateRawValue = url.query?.components(separatedBy: "=").last,
                  let state         = YTPlayerState(rawValue: stateRawValue) else { return }
            onStateChange(state)
        }
    }
}
    
    
// MARK: - Player's JS event handler methods -
private extension YTPlayer {
    
    func onReady() {
        ready = true
    }
    
    
    func onStateChange(_ state: YTPlayerState) {
        self.state = state
        switch state {
        case .playing, .buffering:
            activateTimePublisher()
        default:
            destroyTimePublisher()
        }
        #if DEBUG
        print(state)
        #endif
    }
}
    
 
// MARK: - Current time publisher methods -
private extension YTPlayer {
    
    func activateTimePublisher() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.getCurrentTime()
        }
    }
    
    
    func destroyTimePublisher() {
        getCurrentTime()
        timer?.invalidate()
        timer = nil
    }
}
