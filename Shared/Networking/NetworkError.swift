//
//  NetworkError.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

enum NetworkError: Identifiable {
    
    case urlError(_ error: URLError)
    case responseError(_ error: ResponseError)
    case decodingError(_ error: DecodingError)
    case unexpectedError(_ error: Error)
    
    
    var id:      String             { message }
    var title:   LocalizedStringKey { "Something went wrong...".localized }
    var message: String {
        switch self {
        case .urlError(let error):          return "\n\(error.localizedDescription)"
        case .responseError(let error):     return "\nStatus code: \(error.code). Message:\n\"\(error.message)\""
        case .decodingError(let error):     return "\n\"\(error)\""
        case .unexpectedError(let error):   return "\n\(error.localizedDescription)"
        }
    }
    
    
    init(_ error: Error) {
        switch error.self {
        case let error as URLError:         self = .urlError(error)
        case let error as ResponseError:    self = .responseError(error)
        case let error as DecodingError:    self = .decodingError(error)
        default:                            self = .unexpectedError(error)
        }
        #if DEBUG
        print(error)
        #endif
    }
}


// MARK: - Equatable -
extension NetworkError: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.message == lhs.message
    }
}
