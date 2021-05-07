//
//  VideoLoader.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import Combine
import SwiftUI

typealias ChannelLoader = VideoLoader
class VideoLoader: ObservableObject {
    
    @Published private(set) var videos     = [Video]()
    @Published private(set) var isLoading  = true
    
    @Published private(set) var pageInfos: [String: PageInfo] = [:]
    
    @Published private var _initialized:   Void
    
    private(set) lazy var initialized      = $_initialized.throttle(for: .zero, scheduler: DispatchQueue.main, latest: true)
    
    private(set) var indices: [String: Int]       = [:]
    private var cancellables: Set<AnyCancellable> = []
    
    
    init() {
        self._initialized = ()
    }
    
    deinit { cancel() }
}


// MARK: - 'get' methods -
extension VideoLoader {
    
    func getMostPopularVideos(for region: Region) {
        cancel()
        setLoading()
        emptyVideos()
        NetworkManager.shared
            .getMostPopularVideos(for: region, completion: setVideos)?
            .store(in: &cancellables)
    }
    
    
    func search(for type: YTResourceType, with searchQuery: String, pageToken: String? = nil, maxResults: Int = 50) {
        guard !searchQuery.isEmpty else { return }
        cancel()
        setLoading()
        emptyVideos()
        NetworkManager.shared
            .search(type, with: searchQuery, pageToken: pageToken, maxResults: maxResults) { [weak self] response in
                guard let self = self else { return }
                self.setVideos(from: response)
                self.setPageInfo(from: response, forKey: searchQuery)
                self.get(type, with: response?.ids)
            }?
            .store(in: &cancellables)
    }
    
    
    @objc func getPlaylistItems(playlistId: String?, pageToken: String? = nil) {
        guard let playlistId = playlistId else { return }
        NetworkManager.shared
            .getPlaylistItems(playlistId: playlistId, pageToken: pageToken) { [weak self] response in
                guard let self = self else { return }
                self.updateVideos(with: response)
                self.setPageInfo(from: response, forKey: playlistId)
                self.get(.videos, with: response?.ids, completion: self.updateVideos)
            }?
            .store(in: &cancellables)
    }
    
    
    func get(_ type: YTResourceType, with ids: [String]?, completion: Completion? = nil) {
        guard let ids = ids, !ids.isEmpty else {
            setLoading(false)
            return
        }
        NetworkManager.shared
            .get(type, with: ids, completion: completion ?? setVideos)?
            .store(in: &cancellables)
    }
}


// MARK: - 'set' methods -
extension VideoLoader {
    
    func setLoading(_ newValue: Bool = true) {
        if isLoading != newValue {
            isLoading = newValue
        }
    }
    
    
    func setPageInfo(from response: Response?, forKey key: String) {
        pageInfos[key] = PageInfo(nextPageToken: response?.nextPageToken,
                                  prevPageToken: response?.prevPageToken,
                                  resultsPerPage: response?.pageInfo.resultsPerPage)
    }
    
    
    func setVideos(from response: Response?) {
        defer { setLoading(false) }
        guard let response = response else { return }
        videos = response.items
    }
    
    
    func updateVideos(with response: Response?) {
        defer { setLoading(false) }
        guard let response = response else { return }
        for video in response.items {
            if let i = indices[video.id] {
                videos[i] = video
                continue
            }
            indices[video.id] = videos.count
            videos.append(video)
        }
    }
    
    
    func moveVideo(fromOffsets source: IndexSet, toOffset destination: Int) {
        videos.move(fromOffsets: source, toOffset: destination)
    }
    
    
    func deleteVideo(with videoId: String) {
        videos.removeAll { $0.id == videoId }
    }
    
    
    func emptyVideos() {
        videos.removeAll()
        indices.removeAll()
    }
}


// MARK: - Cancellable -
extension VideoLoader: Cancellable {
    
    func cancel() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        pageInfos.removeAll()
    }
}
