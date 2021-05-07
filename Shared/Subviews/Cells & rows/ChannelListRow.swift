//
//  ChannelListRow.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct ChannelListRow: View {
    
    @State private var id = 0
    private let channel: Channel
    
    var body: some View {
        HStack {
            #if os(iOS)
            NavigationLink(destination: ChannelVideos(channel)) {
                channelRow
            }
            #elseif os(macOS)
            channelRow
            #endif
            Spacer()
            subscribeButton
        }
        .foregroundColor(.primary)
    }
    
    init(_ channel: Channel) {
        self.channel = channel
    }
}


// MARK: - Subviews -
private extension ChannelListRow {
    
    var channelRow: some View {
        HStack {
            ChannelThumbnail(channel)
            VStack(alignment: .leading, spacing: 5) {
                Text(channel.title)
                Text("\(channel.subscriberCount) subscribers")
                    .foregroundColor(.secondary)
                    .if(channel.uploads == nil) { $0.redacted(reason: .placeholder) }
            }
            .lineLimit(1)
            .minimumScaleFactor(0.9)
        }
    }
    
    var subscribeButton: some View {
        #if os(macOS)
        return Button(isSubscriberOfChannel ? "Unsubscribe" : "Subscribe", action: subscribeAction).id(id)
        #elseif os(iOS)
        return Button(action: subscribeAction) {
            Text(isSubscriberOfChannel ? "unsubscribe" : "subscribe")
                .foregroundColor(.secondary)
                .padding(3.5)
                .border(Color.secondary, width: 1.5)
                .font(.callout)
                .id(id)
        }.buttonStyle(BorderlessButtonStyle())
        #endif
    }
}


// MARK: - Methods -
private extension ChannelListRow {
    
    var isSubscriberOfChannel: Bool {
        SubscriptionManager.channelIds.contains(channel.id)
    }
    
    
    func subscribeAction() {
        isSubscriberOfChannel ? SubscriptionManager.unsubscribe(from: channel) : SubscriptionManager.subscribe(to: channel)
        id += 1
    }
}
