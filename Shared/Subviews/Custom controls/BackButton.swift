//
//  BackButton.swift
//  MyYouTube (iOS)
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct BackButton: View {
    
    private let action: () -> Void
    private let text: LocalizedStringKey
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: Images.back)
                    .font(Font.body.bold())
                    .imageScale(.large)
                Text(text).font(.body)
            }.foregroundColor(.accentColor)
        }.padding([.vertical, .trailing])
    }
    
    init(action: @escaping () -> Void, text: LocalizedStringKey = "Back") {
        self.action = action
        self.text   = text
    }
}
