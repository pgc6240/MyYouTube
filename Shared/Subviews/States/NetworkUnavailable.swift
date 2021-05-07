//
//  NetworkUnavailable.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct NetworkUnavailableView: View {
    var body: some View {
        Text("Network is unavailable")
            .fontWeight(.medium)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .background(Color.accentColor)
            .padding(.vertical, -8)
    }
}
