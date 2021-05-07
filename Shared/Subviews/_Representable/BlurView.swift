//
//  BlurView.swift
//  MyYouTube (iOS)
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    
    var style: UIBlurEffect.Style = .systemMaterial
    
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let effect = UIBlurEffect(style: style)
        return UIVisualEffectView(effect: effect)
    }
    
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
