//
//  Constants.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

enum Constants {}


enum Images {
    static let appIcon  = "play.rectangle.fill"
    static let back     = "chevron.left"
    static let forward  = "chevron.right"
    static let play     = "play.fill"
    static let pause    = "pause.fill"
    static let close    = "xmark"
    static let clear    = "xmark.circle"
    static let like     = "hand.thumbsup.fill"
    static let dislike  = "hand.thumbsdown.fill"
    static let comments = "text.bubble.fill"
    static let settings = "gearshape"
}


enum Keys {
    static let selectedTab          = "com.pgc6240.MyYT.RootView.selectedTab"
    static let displaySubscriptions = "com.pgc6240.MyYT.RootView.displaySubscriptions"
    static let region               = "com.pgc6240.MyYT.Settings.region"
    static let displayDescription   = "com.pgc6240.MyYT.Settings.displayDescription"
    static let shared               = "com.pgc6240.MyYT.MyYouTube.shared"
    static let sharedURL            = "com.pgc6240.MyYT.MyYouTube.sharedURL"
    static let sortBy               = "com.pgc6240.MyYT.MyTimeStamps.sortBy"
    static let timeStamps           = "com.pgc6240.MyYT.TimeStampManager.timeStamps"
    static let subscriptions        = "com.pgc6240.MyYT.SubscriptionManager.subscriptions"
    static let systemLanguage       = "AppleLanguages"
}


enum Screen {
    #if os(iOS)
    static let bounds = UIScreen.main.bounds
    static let width  = bounds.width
    static let height = bounds.height
    #elseif os(macOS)
    static let frame     = NSScreen.main?.frame
    static let width     = frame?.width ?? 0
    static let height    = frame?.height ?? 0
    static let halfWidth = width / 2
    #endif
}
