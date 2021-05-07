//
//  MyTimeStampsVL.swift
//  MyYouTube (iOS)
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

final class MyTimeStampsVL: VideoLoader {
    
    
    func getStampedVideos() {
        get(.videos, with: TimeStampManager.shared.videoIds, completion: setStampedVideos)
    }
    
    
    func setStampedVideos(from response: Response?) {
        setVideos(from: response)
        videos.forEach { video in
            video.timeStamp = TimeStampManager.shared.getTimeStamp(with: video.id)
        }
    }
    
    
    func moveStampedVideo(fromOffsets source: IndexSet, toOffset destination: Int) {
        moveVideo(fromOffsets: source, toOffset: destination)
        TimeStampManager.shared.moveTimeStamp(fromOffsets: source, toOffset: destination)
    }
    
    
    func deleteStampedVideo(with videoId: String) {
        deleteVideo(with: videoId)
        TimeStampManager.shared.deleteTimeStamp(with: videoId)
    }
    
    
    func clearStampedVideos() {
        emptyVideos()
        TimeStampManager.shared.clearTimeStamps()
    }
}
