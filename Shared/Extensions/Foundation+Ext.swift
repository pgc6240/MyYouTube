//
//  Foundation+Ext.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import Foundation

extension String {

    var removingWhitespaces: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}


extension Dictionary {
    
    static func + (lhs: Dictionary, rhs: Dictionary) -> Dictionary {
        return lhs.merging(rhs) { _, new in new }
    }
}


extension Dictionary where Key == String, Value == String? {
    
    func sorted() -> Array<(key: String, value: String?)> {
        return sorted { $0.key > $1.key }
    }
}


extension URL {
    
    init?(_ optionalString: String?) {
        guard let string = optionalString else { return nil }
        self.init(string: string)
    }
    
    
    var parameters: [String: String]? {
        query?
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) {
                var parameters    = $0
                parameters[$1[0]] = $1[1]
                return parameters
            }
    }
}


extension JSONDecoder {
    
    convenience init(decodingFrom apiMethod: YTApiMethod) {
        self.init()
        dateDecodingStrategy = .iso8601
        userInfo             = [.decodingFrom: apiMethod]
    }
}


extension CodingUserInfoKey {
    static let decodingFrom = Self(rawValue: "decodingFrom")!
}


extension FileManager {
    static let cachesDirectory = `default`.urls(for: .cachesDirectory, in: .userDomainMask).first
}
