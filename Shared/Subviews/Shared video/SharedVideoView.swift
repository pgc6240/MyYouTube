//
//  SharedVideoView.swift
//  MyYouTube (iOS)
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct SharedVideoView: View {
    
    @EnvironmentObject private var videoLoader: MyYouTube
    @State private var playSharedVideo = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            if let sharedVideo = videoLoader.sharedVideo {
                Text("Video shared from YouTube app:")
                    .italic()
                    .padding(.top, 10)
                NavigationLink(destination: PlayerView(sharedVideo).navigationBarHidden(true), isActive: $playSharedVideo) {
                    VideoCell(sharedVideo).padding(.bottom, 5)
                }
            }
        }
        .background(Color.placeholder)
        .onAppear(perform: checkForSharedVideo)
        .id(videoLoader.sharedVideo?.id)
    }
    
    
    func checkForSharedVideo() {
        playSharedVideo = videoLoader.checkForSharedVideo()
    }
}
