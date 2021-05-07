//
//  Settings.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

final class Settings: ObservableObject {

    @AppStorage(Keys.region) var region = Region.RU
    @AppStorage(Keys.displayDescription) var displayDescription = false
    
    
    init() {
        F.df1.locale = region.locale
        F.df2.locale = region.locale
    }
    
    
    func regionChanged(to region: Region) {
        F.df1.locale = region.locale
        F.df2.locale = region.locale
        UserDefaults.standard.set([region.identifier], forKey: Keys.systemLanguage)
    }
}
