//
//  Video.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import Foundation

typealias Channel = Video
final class Video: Identifiable, Decodable {
    
    let id: String
    let title: String
    let description: String
    let _publishedAt: Date, publishedAt: String
    let channelId: String, channelTitle: String
    let _viewCount: Int, _subscriberCount: Int
    let viewCount: String, likeCount: String, dislikeCount: String, commentCount: String, subscriberCount: String
    let highSizeThumbnailUrl: String, maxSizeThumbnailUrl: String?
    let _duration: Float?, duration: String?
    let uploads: String?
    var timeStamp: TimeStamp?
    
    
    //
    // MARK: - Decodable -
    //
    private enum CodingKeys: CodingKey {
        
        case snippet, resourceId
        case thumbnails
        case statistics
        case contentDetails, relatedPlaylists
        
        case id, videoId
        case title
        case description
        case publishedAt, videoPublishedAt
        case channelId, channelTitle
        case viewCount, likeCount, dislikeCount, commentCount, subscriberCount
        case duration
        case uploads
        case url
    }
    

    init(from decoder: Decoder) throws {
        guard let decodingFrom = decoder.userInfo[.decodingFrom] as? YTApiMethod else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let snippetContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .snippet)
        let id: String
        switch decodingFrom {
        case .videos_list:
            id = try container.decode(String.self, forKey: .id)
        case .search_list:
            let idContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .id)
            do {
                id = try idContainer.decode(String.self, forKey: .videoId)
            } catch {
                id = try idContainer.decode(String.self, forKey: .channelId)
            }
        case .playlistItems_list:
            let resourceIdContainer = try snippetContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .resourceId)
            id = try resourceIdContainer.decode(String.self, forKey: .videoId)
        case .channels_list:
            id = try container.decode(String.self, forKey: .id)
        }
        self.id = id
        let title = try snippetContainer.decode(String.self, forKey: .title)
        self.title = title
        self.description = try snippetContainer.decode(String.self, forKey: .description)
        var publishedAt = (try? snippetContainer.decode(Date.self, forKey: .publishedAt)) ?? Date()
        self.channelId = (try? snippetContainer.decode(String.self, forKey: .channelId)) ?? id
        self.channelTitle = (try? snippetContainer.decode(String.self, forKey: .channelTitle)) ?? title
        let thumbnailsContainer = try snippetContainer.nestedContainer(keyedBy: Thumbnail.Size.self, forKey: .thumbnails)
        var thumbnails = [Thumbnail]()
        for size in Thumbnail.Size.allCases {
            guard let thumbnailContainer = try? thumbnailsContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: size) else { continue }
            let url = try thumbnailContainer.decode(String.self, forKey: .url)
            let thumbnail = Thumbnail(size: size, url: url)
            thumbnails.append(thumbnail)
        }
        self.highSizeThumbnailUrl = thumbnails.first(where: { $0.size == .high })?.url ?? ""
        self.maxSizeThumbnailUrl = thumbnails.max()?.url
        let statisticsContainer = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .statistics)
        let viewCount = try? statisticsContainer?.decode(String.self, forKey: .viewCount)
        let likeCount = try? statisticsContainer?.decode(String.self, forKey: .likeCount)
        let dislikeCount = try? statisticsContainer?.decode(String.self, forKey: .dislikeCount)
        let commentCount = try? statisticsContainer?.decode(String.self, forKey: .commentCount)
        let subscriberCount = try? statisticsContainer?.decode(String.self, forKey: .subscriberCount)
        self._viewCount = Int(viewCount ?? "0") ?? 0
        self._subscriberCount = Int(subscriberCount ?? "0") ?? 0
        self.viewCount = F.formatNumber(viewCount ?? "0")
        self.likeCount = F.formatNumber(likeCount ?? "0")
        self.dislikeCount = F.formatNumber(dislikeCount ?? "0")
        self.commentCount = F.formatNumber(commentCount ?? "0")
        self.subscriberCount = F.formatNumber(subscriberCount ?? "0")
        let contentDetailsContainer = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .contentDetails)
        let duration = try? contentDetailsContainer?.decode(String.self, forKey: .duration)
        self._duration = F.formatDuration(duration)
        self.duration = F.formatTime(_duration)
        if decodingFrom == .playlistItems_list,
           let videoPublishedAt = try? contentDetailsContainer?.decode(Date.self, forKey: .videoPublishedAt) {
            publishedAt = videoPublishedAt
        }
        self._publishedAt = publishedAt
        self.publishedAt = F.formatDate(publishedAt)
        let relatedPlaylistsContainer = try? contentDetailsContainer?.nestedContainer(keyedBy: CodingKeys.self, forKey: .relatedPlaylists)
        self.uploads = try relatedPlaylistsContainer?.decode(String.self, forKey: .uploads)
    }
}
