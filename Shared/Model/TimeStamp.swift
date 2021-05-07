//
//  TimeStamp.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import Foundation

final class TimeStamp: NSObject, NSCoding {
    
    let videoId: String
    let time:    Float
    let addedAt: Date
    
    
    init(videoId: String, time: Float) {
        self.videoId = videoId
        self.time    = time
        self.addedAt = Date()
    }
    
    
    init?(coder: NSCoder) {
        self.videoId = coder.decodeObject(forKey: "videoId") as! String
        self.time    = coder.decodeFloat(forKey: "time")
        self.addedAt = coder.decodeObject(forKey: "addedAt") as! Date
    }
    
    
    func encode(with coder: NSCoder) {
        coder.encode(videoId, forKey: "videoId")
        coder.encode(time, forKey: "time")
        coder.encode(addedAt, forKey: "addedAt")
    }
}
