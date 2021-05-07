//
//  Enumerations.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

enum Region: String, CaseIterable {
    
    case RU
    case US
    
    var code: String { rawValue }
    var description: String {
        switch self {
        case .RU: return "русский / Россия"
        case .US: return "English / USA"
        }
    }
    var identifier: String {
        switch self {
        case .RU: return "ru"
        case .US: return "en"
        }
    }
    var locale: Locale { Locale(identifier: identifier) }
}


enum Tab: String {
    
    case main         = "Main"
    case myTimeStamps = "My time stamps"
    case videoFeed    = "Video feed"
    
    var title: LocalizedStringKey { rawValue.localized }
    var icon:  String {
        switch self {
        case .main:         return "house.fill"
        case .myTimeStamps: return "square.and.pencil"
        case .videoFeed:    return "play.rectangle.fill"
        }
    }
}


enum YTResourceType: String {
    
    case videos    = "video"
    case channels  = "channel"
    
    var apiMethod: YTApiMethod {
        switch self {
        case .videos:   return .videos_list
        case .channels: return .channels_list
        }
    }
}
