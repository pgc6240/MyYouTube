//
//  RootView.swift
//  MyYouTube (macOS)
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct RootView: View {
    
    @SceneStorage(Keys.displaySubscriptions) private var displaySubscriptions = true
    @EnvironmentObject private var myYouTube: MyYouTube
    private let sidebarWidth: CGFloat = 360
    
    var body: some View {
        HSplitView {
            if displaySubscriptions {
                Subscriptions($displaySubscriptions).frame(width: sidebarWidth)
            }
            
            VideoFeed()
                .frame(width: videoFeedWidth)
                .toolbar { subscriptionsButton }
            
            if let selectedVideo = myYouTube.selectedVideo {
                PlayerView(selectedVideo)
                    .frame(width: Screen.halfWidth)
                    .id(selectedVideo.id)
            }
        }
        .onReceive(myYouTube.$selectedVideo, perform: hideSubscriptions)
        .frame(width: 1440, height: 746)
        .frame(maxHeight: .infinity)
    }
}


// MARK: - Internal properties & subviews -
private extension RootView {
    
    var videoFeedWidth: CGFloat {
        switch (myYouTube.selectedVideo == nil, displaySubscriptions) {
        case (true, false):
            return Screen.width
        case (false, _):
            return Screen.halfWidth
        case (true, true):
            return Screen.width - sidebarWidth
        }
    }
    
    var subscriptionsButton: some View {
        Button("Subscriptions", action: showSubscriptions).foregroundColor(.primary)
    }
}


// MARK: - Internal methods -
private extension RootView {
    
    func showSubscriptions() {
        myYouTube.selectedVideo = nil
        displaySubscriptions.toggle()
    }
    
    
    func hideSubscriptions(_ selectedVideo: Video?) {
        guard selectedVideo != nil else { return }
        displaySubscriptions = false
    }
}
