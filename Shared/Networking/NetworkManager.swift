//
//  NetworkManager.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI
import Combine
import Network

final class NetworkManager: NSObject, ObservableObject {
    
    // MARK: - Singleton -
    static let shared = NetworkManager()
    
    private override init() {
        super.init()
        startMonitoringNetworkStatus()
    }
    
    
    // MARK: - Internal properties -
    private let monitor = NWPathMonitor()
    private var requests: Set<URLRequest> = []
    private lazy var session: URLSession  = {
        let configuration                  = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
    }()
    
    
    // MARK: - External properties -
    @Published private(set) var networkIsUnavailable = false
    @Published private(set) var networkError: NetworkError?
}
  
 
// MARK: - Internal methods -
private extension NetworkManager {
    
    func getVideos(_ apiMethod: YTApiMethod,
                   with parameters: Parameters,
                   returnCachedResponse: Bool = true,
                   completion: @escaping Completion) -> AnyCancellable? {
        let request = URLRequestBuilder.buildURLRequest(apiMethod, with: parameters)
        let decoder = JSONDecoder(decodingFrom: apiMethod)
        if returnCachedResponse || networkIsUnavailable || networkError != nil {
            getCachedResponse(for: request, decodeWith: decoder, completion: completion)
        }
        guard requests.insert(request).inserted else { return nil }
        return session.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .tryMap(tryMapData)
            .decode(type: Response?.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: catchError, receiveValue: completion)
    }
    
    
    func getCachedResponse(for request: URLRequest, decodeWith decoder: JSONDecoder, completion: @escaping Completion) {
        if let cachedResponse = URLCache.shared.cachedResponse(for: request),
           let response       = try? decoder.decode(Response.self, from: cachedResponse.data) {
            completion(response)
        }
    }
    
    
    func tryMapData(_ data: Data, _ response: URLResponse) throws -> Data {
        if let httpResponse  = response as? HTTPURLResponse, httpResponse.statusCode != 200,
           let responseError = try? JSONDecoder().decode(ResponseError.self, from: data) {
            throw responseError
        }
        return data
    }
    
    
    func catchError(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            if networkError != nil {
                networkError = nil
            }
        case .failure(let error):
            let networkError = NetworkError(error)
            if self.networkError != networkError {
                self.networkError = networkError
            }
        }
    }
    
    
    func startMonitoringNetworkStatus() {
        monitor.start(queue: .main)
        monitor.pathUpdateHandler = { path in
            withAnimation { [weak self] in
                guard let self = self else { return }
                let networkIsUnavailable = path.status != .satisfied
                if self.networkIsUnavailable != networkIsUnavailable {
                    self.networkIsUnavailable = networkIsUnavailable
                }
            }
        }
    }
}


// MARK: - External methods -
extension NetworkManager {
    
    func getMostPopularVideos(for region: Region, maxResults: Int = 5, completion: @escaping Completion) -> AnyCancellable? {
        let parameters = [
            "chart"      : "mostPopular",
            "regionCode" : region.code,
            "maxResults" : String(maxResults)
        ]
        return getVideos(.videos_list, with: parameters, completion: completion)
    }
    
    
    func search(_ type: YTResourceType,
                with searchQuery: String,
                pageToken: String? = nil,
                maxResults: Int = 50,
                completion: @escaping Completion) -> AnyCancellable? {
        let parameters = [
            "q"          : searchQuery,
            "type"       : type.rawValue,
            "pageToken"  : pageToken,
            "maxResults" : String(maxResults)
        ]
        return getVideos(.search_list, with: parameters, returnCachedResponse: false, completion: completion)
    }
    
    
    func getPlaylistItems(playlistId: String,
                          pageToken: String? = nil,
                          maxResults: Int = 50,
                          completion: @escaping Completion) -> AnyCancellable? {
        let parameters = [
            "playlistId" : playlistId,
            "pageToken"  : pageToken,
            "maxResults" : String(maxResults)
        ]
        return getVideos(.playlistItems_list, with: parameters, completion: completion)
    }
    
    
    func get(_ type: YTResourceType, with ids: [String], completion: @escaping Completion) -> AnyCancellable? {
        let parameters = [
            "id"         : ids.joined(separator: ",")
        ]
        return getVideos(type.apiMethod, with: parameters, completion: completion)
    }
}


// MARK: - URLSessionTaskDelegate -
extension NetworkManager: URLSessionTaskDelegate {
        
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        guard let request = task.originalRequest, let url = request.url else { return }
        requests.remove(request)
        #if DEBUG
        print(metrics.taskInterval.duration, url)
        #endif
    }
}
