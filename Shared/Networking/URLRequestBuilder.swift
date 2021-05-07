//
//  URLRequestBuilder.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import Foundation

typealias Parameters    = [String: String?]
typealias Completion    = (Response?) -> Void
typealias YTApiMethod   = URLRequestBuilder.YTApiMethod

enum URLRequestBuilder {
    
    private static let baseURL  = "https://www.googleapis.com"
    
    enum YTApiMethod: String {
        var path: String        { "/youtube/v3" + rawValue }
        
        case videos_list        = "/videos"
        case search_list        = "/search"
        case playlistItems_list = "/playlistItems"
        case channels_list      = "/channels"
        
        var parameters: Parameters {
            switch self {
            case .videos_list, .channels_list: return ["part": "snippet,statistics,contentDetails"]
            case .search_list:                 return ["part": "snippet", "safeSearch": "none"]
            case .playlistItems_list:          return ["part": "snippet,contentDetails"]
            }
        }
    }
    
    static func buildURLRequest(_ apiMethod: YTApiMethod, with parameters: Parameters) -> URLRequest {
        var components          = URLComponents(string: baseURL)
        components?.path        = apiMethod.path
        let parameters          = apiMethod.parameters + parameters + ["key": Constants.API_KEY]
        components?.queryItems  = parameters.sorted().map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = components?.url else { fatalError() }
        return URLRequest(url: url)
    }
}
