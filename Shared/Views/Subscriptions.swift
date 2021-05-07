//
//  Subscriptions.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct Subscriptions: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var channelLoader = ChannelLoader()
    @Binding private var displaySubscriptions: Bool
    @State private var isSearching = false
    @State private var searchQuery = ""
    @State private var title = "Subscriptions".localized
    
    var body: some View {
        List {
            closeButton
            searchField
            if channelLoader.isLoading {
                ProgressView()
            } else if channelLoader.videos.isEmpty {
                EmptyStateView(isSearching ? "No search results." : "You haven't subscribed any channel yet.")
            } else {
                ForEach(channelLoader.videos.sorted { $0._subscriberCount > $1._subscriberCount }) { channel in
                    ChannelListRow(channel)
                }
            }
        }
        .onReceive(channelLoader.initialized, perform: loadSubscriptions)
        .toolbar { backButton }
        .navigationTitle(title)
    }
    
    init(_ displaySubscriptions: Binding<Bool> = .constant(true)) {
        self._displaySubscriptions = displaySubscriptions
    }
}


// MARK: - Subviews -
private extension Subscriptions {
    
    var closeButton: some View {
        #if os(macOS)
        return Button("Close", action: close)
        #else
        return EmptyView()
        #endif
    }
    
    var searchField: some View {
        SearchField("Search channels...", query: $searchQuery, onCommit: searchChannels, rounded: true)
            .padding(.vertical, 5)
    }
    
    var backButton: some ToolbarContent {
        #if os(iOS)
        return ToolbarItem(placement: .navigationBarLeading) {
            BackButton(action: close, text: isSearching ? "Subscriptions" : "Back").padding(.leading, -7.5)
        }
        #else
        return ToolbarItem {}
        #endif
    }
}


// MARK: - Internal methods -
private extension Subscriptions {
    
    func loadSubscriptions() {
        channelLoader.get(.channels, with: SubscriptionManager.channelIds)
        isSearching = false
        searchQuery = ""
        title       = "Subscriptions"
    }
    
    
    func searchChannels() {
        channelLoader.search(for: .channels, with: searchQuery)
        isSearching = true
        searchQuery = ""
        title       = "Search"
    }
    
    
    func close() {
        if isSearching {
            channelLoader.cancel()
            channelLoader.setLoading()
            channelLoader.emptyVideos()
            loadSubscriptions()
        } else {
            presentationMode.wrappedValue.dismiss()
            displaySubscriptions = false
        }
    }
}
