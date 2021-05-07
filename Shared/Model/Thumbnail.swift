//
//  Thumbnail.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

struct Thumbnail: Comparable {
    
    enum Size: CodingKey, CaseIterable, Comparable {
        case `default`, medium, high, standard, maxres
    }
    
    let size: Size
    let url: String
    
    
    // MARK: - Comparable -
    static func < (lhs: Thumbnail, rhs: Thumbnail) -> Bool {
        lhs.size < rhs.size
    }
}
