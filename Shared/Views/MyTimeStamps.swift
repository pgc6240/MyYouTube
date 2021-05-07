//
//  MyTimeStamps.swift
//  MyYouTube (iOS)
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct MyTimeStamps: View {
    
    @AppStorage(Keys.sortBy) private var sortBy = SortBy.newFirst
    @StateObject private var videoLoader = MyTimeStampsVL()
    @State private var id = 0
    
    var body: some View {
        List {
            sortBySegmentedPicker
            clearTimeStampsButton
            if videoLoader.isLoading {
                ProgressView()
            } else if videoLoader.videos.isEmpty {
                EmptyStateView("No time stamps. Yet.")
            } else {
                ForEach(videoLoader.videos.sorted(by: sortMethod)) { video in
                    NavigationLink(destination: PlayerView(video).navigationBarHidden(true)) {
                        VideoListRow(video, videoList: .myTimeStamps)
                    }
                }
                .onMove(perform: onMove)
                .onDelete(perform: onDelete)
            }
        }
        .id(id)
        .onReceive(videoLoader.initialized, perform: getStampedVideos)
        .onReceive(TimeStampManager.shared.publisher, perform: videoLoader.getStampedVideos)
        .navigationBarItems(trailing: editButton)
    }
}


//MARK: - Subviews -
private extension MyTimeStamps {
    
    var sortBySegmentedPicker: some View {
        HStack {
            Text("Sort by:")
            Picker("", selection: $sortBy) {
                ForEach(SortBy.allCases, id: \.self) { sortBy in
                    Text(sortBy.rawValue.localized)
                }
            }.pickerStyle(SegmentedPickerStyle())
        }
    }
    
    var clearTimeStampsButton: some View {
        HStack {
            Button("Clear timestamps", action: videoLoader.clearStampedVideos)
            Spacer()
            Text("\(String(TimeStampManager.shared.timeStamps.count)) videos").foregroundColor(.secondary)
        }
    }
    
    var editButton: some View {
        EditButton().disabled(sortBy != .manually)
    }
}


//MARK: - Methods -
private extension MyTimeStamps {
    
    func getStampedVideos() {
        id += 1
        videoLoader.getStampedVideos()
    }
    
    
    func sortMethod(_ video1: Video, _ video2: Video) -> Bool {
        guard let timeStamp1 = video1.timeStamp,
              let timeStamp2 = video2.timeStamp else { return false }
        switch sortBy {
        case .newFirst: return timeStamp1.addedAt > timeStamp2.addedAt
        case .oldFirst: return timeStamp1.addedAt < timeStamp2.addedAt
        case .manually: return false
        }
    }
    
    
    func onMove(_ indices: IndexSet, _ newOffset: Int) {
        videoLoader.moveStampedVideo(fromOffsets: indices, toOffset: newOffset)
    }
    
    
    func onDelete(_ indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let sortedVideos = videoLoader.videos.sorted(by: sortMethod)
        let videoToDelete = sortedVideos[index]
        videoLoader.deleteStampedVideo(with: videoToDelete.id)
    }
}


// MARK: - SortBy -
fileprivate enum SortBy: String, CaseIterable {
    case newFirst = "New first"
    case oldFirst = "Old first"
    case manually = "Manually"
}
