//
//  PlayerButton.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct PlayerButton: View {
    
    let imageName: String
    
    var body: some View {
        Image(systemName: imageName)
            .frame(width: 42, height: 42)
            .background(Color.black.opacity(0.75))
            .foregroundColor(Color.white.opacity(0.9))
            .padding(.top, iOS ? 30 : 6)
            .padding(.horizontal, 6)
    }
}
