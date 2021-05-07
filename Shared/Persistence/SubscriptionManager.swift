//
//  SubscriptionManager.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import Combine

final class SubscriptionManager: ObservableObject {
    
    @UserDefault(key: Keys.subscriptions, defaultValue: [:])
    static private(set) var subscriptions: [String: String] {
        didSet { publisher.send() }
    }
    
    static var channelIds:  [String] { Array(subscriptions.keys) }
    static var playlistIds: [String] { Array(subscriptions.values) }
    
    static let publisher = ObjectWillChangePublisher()
    
    
    static func subscribe(to channel: Channel) {
        subscriptions[channel.id] = channel.uploads
    }
    
    
    static func unsubscribe(from channel: Channel) {
        subscriptions[channel.id] = nil
    }
}
