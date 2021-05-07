//
//  VideoDescription.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct VideoDescription: View {
    
    @AppStorage(Keys.displayDescription) private var displayDescription = true
    private let video: Video
    
    var body: some View {
        DisclosureGroup(isExpanded: $displayDescription) {
            Divider()
            _TextView(video.description).aspectRatio(contentMode: .fill)
        } label: {
            Text("Description:")
                .font(macOS ? .title2 : .body)
                .onTapGesture(perform: toggleDescription)
        }
    }
    
    init(_ video: Video) {
        self.video = video
    }
    
    
    func toggleDescription() {
        withAnimation {
            displayDescription.toggle()
        }
    }
}
