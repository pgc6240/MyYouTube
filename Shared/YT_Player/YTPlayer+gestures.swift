//
//  YTPlayer+gestures.swift
//  MyYouTube (iOS)
//
//  Created by pgc6240 on 07.05.2021.
//

import UIKit

extension YTPlayer: UIGestureRecognizerDelegate {
    
    enum GestureName: String {
        case forwards
        case backwards
    }
    
    
    func configureDoubleTapGestures() {
        let forwardGesture = UITapGestureRecognizer(target: self, action: #selector(forwardsXsec))
        forwardGesture.name = GestureName.forwards.rawValue
        forwardGesture.numberOfTapsRequired = 2
        forwardGesture.delegate = self
        let backwardGesture = UITapGestureRecognizer(target: self, action: #selector(backwardsXsec))
        backwardGesture.name = GestureName.backwards.rawValue
        backwardGesture.numberOfTapsRequired = 2
        backwardGesture.delegate = self
        webView?.addGestureRecognizer(forwardGesture)
        webView?.addGestureRecognizer(backwardGesture)
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let gestureName = gestureRecognizer.name, let view = touch.view else { return false }
        switch gestureName {
        case GestureName.forwards.rawValue: return touch.location(in: view).x >= view.bounds.midX
        case GestureName.backwards.rawValue: return touch.location(in: view).x < view.bounds.midX
        default: return false
        }
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
    
    @objc func forwardsXsec() {
        currentTime += 30
        seekTo(time: currentTime)
    }
    
    
    @objc func backwardsXsec() {
        currentTime -= 10
        seekTo(time: currentTime)
    }
}
