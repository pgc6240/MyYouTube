//
//  TimeStampManager.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

final class TimeStampManager: ObservableObject {
    
    // MARK: - Singleton -
    static let shared = TimeStampManager()
    
    private init() {}
    
    
    // MARK: - External properties -
    @UserDefault(key: Keys.timeStamps, defaultValue: [])
    private(set) var timeStamps: [TimeStamp] {
        didSet { publisher.send() }
    }
    
    var videoIds: [String] { timeStamps.map { $0.videoId }}
    
    let publisher = ObjectWillChangePublisher()
}

 
// MARK: - External methods -
extension TimeStampManager {
    
    func setTimeStamp(videoId: String, time: Float) {
        if let index = timeStamps.firstIndex(where: { $0.videoId == videoId }) {
            timeStamps.remove(at: index)
        }
        let timeStamp = TimeStamp(videoId: videoId, time: time)
        timeStamps.append(timeStamp)
    }
    
    
    func getTimeStamp(with videoId: String) -> TimeStamp? {
        timeStamps.first { $0.videoId == videoId }
    }
    
    
    func moveTimeStamp(fromOffsets source: IndexSet, toOffset destination: Int) {
        timeStamps.move(fromOffsets: source, toOffset: destination)
    }
    
    
    func deleteTimeStamp(with videoId: String) {
        timeStamps.removeAll { $0.videoId == videoId }
    }
    
    
    func clearTimeStamps() {
        timeStamps.removeAll()
    }
}
