//
//  YTPlayer+JSMethod.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import Foundation

private extension YTPlayer {
    
    enum YTPlayerMethod {
        
        case playVideo
        case pauseVideo
        case stopVideo
        case seekTo(_ time: Float)
        case getCurrentTime
        
        var string: String {
            switch self {
            case .playVideo:        return "playVideo()"
            case .pauseVideo:       return "pauseVideo()"
            case .stopVideo:        return "stopVideo()"
            case .seekTo(let time): return "seekTo(\(time), true)"
            case .getCurrentTime:   return "getCurrentTime()"
            }
        }
    }
    
    
    func evaluateJavaScript(_ ytPlayerMethod: YTPlayerMethod) {
        let javaScriptString = "player." + ytPlayerMethod.string + ";"
        webView?.evaluateJavaScript(javaScriptString) { [weak self] result, error in
            guard let self = self, error == nil else { return }
            switch ytPlayerMethod {
            case .getCurrentTime:
                guard let number = result as? NSNumber else { return }
                self.currentTime = number.floatValue
                #if DEBUG
                print(number.floatValue)
                #endif
            default: break
            }
        }
    }
}


// MARK: - External JavaScript methods -
extension YTPlayer {
    
    func play() {
        evaluateJavaScript(.playVideo)
    }
    
    
    func pause() {
        evaluateJavaScript(.pauseVideo)
    }
    
    
    func stop() {
        evaluateJavaScript(.stopVideo)
    }
    
    
    func seekTo(time: Float) {
        evaluateJavaScript(.seekTo(time))
    }
    
    
    func getCurrentTime() {
        evaluateJavaScript(.getCurrentTime)
    }
}
