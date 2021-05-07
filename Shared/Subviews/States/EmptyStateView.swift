//
//  EmptyStateView.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct EmptyStateView: View {
    
    @EnvironmentObject private var networkManager: NetworkManager
    private let message: LocalizedStringKey
    private let color: Color
    
    var body: some View {
        if networkManager.networkIsUnavailable || networkManager.networkError != nil {
            Text("Something went wrong...")
                .foregroundColor(.accentColor)
                .font(Font.headline.smallCaps())
        } else {
            Text(message).foregroundColor(color)
        }
    }
    
    init(_ message: LocalizedStringKey, color: Color = .secondary) {
        self.message = message
        self.color   = color
    }
}
