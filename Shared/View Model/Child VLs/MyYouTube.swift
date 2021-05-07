//
//  MyYouTube.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

final class MyYouTube: VideoLoader {
    
    @Published var selectedVideo: Video?
    
    @AppStorage(Keys.selectedTab) private var selectedTab = Tab.main
    
    @UserDefault(userDefaults: .myYouTube, key: Keys.shared, defaultValue: false) private(set) var shared: Bool
    @UserDefault(userDefaults: .myYouTube, key: Keys.sharedURL, defaultValue: nil) private(set) var sharedURL: URL?
    
    var sharedVideo: Video? { videos.first }

    
    @discardableResult
    func checkForSharedVideo() -> Bool {
        guard shared || sharedVideo == nil, let videoId = sharedURL?.parameters?["v"] else { return false }
        if shared {
            selectedTab = .videoFeed
        }
        get(.videos, with: [videoId])
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.shared = false
        }
        return shared
    }
}
