//
//  MyYouTubeApp.swift
//  Shared
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

@main
struct MyYouTubeApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject private var videoPlayer = YTPlayer()
    @StateObject private var networkManager = NetworkManager.shared
    @StateObject private var myYouTube = MyYouTube()
    @StateObject private var settings = Settings()
    @State private var networkError: NetworkError?
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(videoPlayer)
                .environmentObject(networkManager)
                .environmentObject(myYouTube)
                .environmentObject(settings)
                .environment(\.locale, settings.region.locale)
                .onReceive(networkManager.$networkError, perform: gotError)
                .alert(item: $networkError) {
                    Alert(title: Text($0.title), message: Text($0.message), dismissButton: .destructive(Text("Cancel")))
                }
        }.onChange(of: scenePhase, perform: scenePhaseChanged)
    }
}


// MARK: - Internal methods -
private extension MyYouTubeApp {
    
    func gotError(_ networkError: NetworkError?) {
        guard networkError != nil else { return }
        self.networkError   = networkError
    }
    
    
    func scenePhaseChanged(_ scenePhase: ScenePhase) {
        switch scenePhase {
        case .background:   break
        case .inactive:     videoPlayer.setTimeStamp()
        case .active:       myYouTube.checkForSharedVideo()
        @unknown default:   break
        }
    }
}
