//
//  _TextView.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct _TextView: _ViewRepresentable {
    
    let text: String
    
    
    init(_ text: String) {
        self.text = text
    }
    
    
    #if os(iOS)
    func makeUIView(context: Context) -> UITextView {
        let textView                               = UITextView()
        textView.attributedText                    = NSAttributedString(string: text)
        textView.font                              = .preferredFont(forTextStyle: .body)
        textView.textColor                         = .label
        textView.textContainerInset                = .zero
        textView.textContainer.lineFragmentPadding = .zero
        textView.dataDetectorTypes                 = [.link]
        textView.isEditable                        = false
        textView.showsVerticalScrollIndicator      = false
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {}
    
    
    #elseif os(macOS)
    func makeNSView(context: Context) -> NSTextView {
        let textView                             = NSTextView()
        textView.string                          = text
        textView.font                            = .preferredFont(forTextStyle: .body, options: [:])
        textView.backgroundColor                 = .clear
        textView.isEditable                      = true
        textView.isAutomaticLinkDetectionEnabled = true
        textView.linkTextAttributes              = [.foregroundColor: NSColor.accentColor]
        textView.checkTextInDocument(nil)
        textView.isEditable                      = false
        return textView
    }
    
    func updateNSView(_ nsView: NSTextView, context: Context) {}
    #endif
}
