//
//  YTPlayer+makeView.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import WebKit

extension YTPlayer: _ViewRepresentable {
    
    #if os(iOS)
    func makeUIView(context: Context) -> WKWebView {
        let config                       = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        webView                          = WKWebView(frame: .zero, configuration: config)
        webView?.isOpaque                = false
        webView?.navigationDelegate      = self
        configureDoubleTapGestures()
        return webView!
    }
    
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    #elseif os(macOS)
    func makeNSView(context: Context) -> WKWebView {
        webView                          = WKWebView(frame: .zero)
        webView?.navigationDelegate      = self
        webView?.setValue(true, forKey: "drawsTransparentBackground")
        return webView!
    }
    
    
    func updateNSView(_ nsView: WKWebView, context: Context) {}
    #endif
}
