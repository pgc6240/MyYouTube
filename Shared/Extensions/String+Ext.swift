//
//  String+Ext.swift
//  MyYouTube
//
//  Created by pgc6240 on 08.05.2021.
//

import Foundation

extension String {
    
    init?(fromResourceFile fileName: String) {
        let fileName = fileName.components(separatedBy: ".")
        let name = fileName.first
        let ext = fileName.last
        guard let path = Bundle.main.path(forResource: name, ofType: ext) else { return nil }
        try? self.init(contentsOfFile: path)
    }
}
