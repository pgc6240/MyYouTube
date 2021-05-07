//
//  Response.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

final class Response: Decodable {
    let items: [Video]
    let nextPageToken: String?
    let prevPageToken: String?
    let pageInfo: Response.PageInfo
    struct PageInfo: Decodable {
        let resultsPerPage: Int
    }
    var ids: [String] {
        items.map { $0.id }
    }
}
