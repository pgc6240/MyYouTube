//
//  LoadingView.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView {
            Text("Loading...").font(Font.body.smallCaps())
        }
    }
}
