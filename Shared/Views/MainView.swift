//
//  MainView.swift
//  MyYouTube (iOS)
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var settings: Settings
    @StateObject private var videoLoader = VideoLoader()
    @State private var header = "5 most popular videos in USA".localized
    @State private var searchQuery = ""
    @State private var isSearching = false
    @State private var showSettings = false
    @State private var pageControlId = 0
    
    var body: some View {
        List {
            Section(header: Text("Search")) {
                SearchField("Search videos...", query: $searchQuery, onCommit: searchVideos)
            }
            Section(header: Text(header).lineLimit(1)) {
                if isSearching {
                    PageControl(delegate: self, dataSource: videoLoader).id(pageControlId)
                }
                if videoLoader.isLoading {
                    ProgressView()
                } else if videoLoader.videos.isEmpty {
                    EmptyStateView(isSearching ? "No search results." : "Something went wrong...")
                } else {
                    ForEach(videoLoader.videos) { video in
                        NavigationLink(destination: PlayerView(video).navigationBarHidden(true)) {
                            VideoListRow(video, videoList: isSearching ? .videosSearch : .mostPopular)
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .onReceive(videoLoader.initialized, perform: getMostPopularVideos)
        .navigationBarItems(leading: backButton, trailing: settingsButton)
        .sheet(isPresented: $showSettings) { SettingsView() }
    }
}


// MARK: - Subviews -
private extension MainView {
    
    var backButton: some View {
        BackButton(action: getMostPopularVideos).opacity(isSearching ? 1 : 0)
    }
    
    var settingsButton: some View {
        Image(systemName: Images.settings)
            .font(.body)
            .foregroundColor(.accentColor)
            .padding([.leading, .vertical])
            .onTapGesture { showSettings = true }
    }
}


// MARK: - Internal methods -
private extension MainView {
    
    func getMostPopularVideos() {
        videoLoader.getMostPopularVideos(for: settings.region)
        header      = "5 most popular videos in USA"
        searchQuery = ""
        isSearching = false
    }
    
    
    func searchVideos() {
        videoLoader.search(for: .videos, with: searchQuery)
        header         = "Search results for \"\(searchQuery)\""
        isSearching    = true
        pageControlId += 1
    }
}


// MARK: - PageControlDelegate -
extension MainView: PageControlDelegate {
    
    func goToPage(with pageToken: String) {
        if videoLoader.pageInfos[searchQuery] == nil {
            searchVideos()
            return
        }
        videoLoader.search(for: .videos, with: searchQuery, pageToken: pageToken)
    }
}
