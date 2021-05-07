//
//  ResponseError.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

struct ResponseError: Error, Decodable {
    
    let code: Int
    let message: String
    
    private enum CodingKeys: CodingKey {
        case error
        case code, message
    }
    
    init(from decoder: Decoder) throws {
        let container       = try decoder.container(keyedBy: CodingKeys.self)
        let errorContainer  = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .error)
        self.code           = try errorContainer.decode(Int.self, forKey: .code)
        self.message        = try errorContainer.decode(String.self, forKey: .message)
    }
}
