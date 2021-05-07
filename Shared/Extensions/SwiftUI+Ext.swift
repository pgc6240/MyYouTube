//
//  SwiftUI+Ext.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

#if os(iOS)
let iOS = true
let macOS = false
typealias _ViewRepresentable = UIViewRepresentable
#elseif os(macOS)
let macOS = true
let iOS = false
typealias _ViewRepresentable = NSViewRepresentable
#endif

extension Image {
    
    init?(contentsOfFile path: String) {
        #if os(iOS)
        guard let uiImage = UIImage(contentsOfFile: path) else { return nil }
        self.init(uiImage: uiImage)
        #elseif os(macOS)
        guard let nsImage = NSImage(contentsOfFile: path) else { return nil }
        self.init(nsImage: nsImage)
        #endif
    }
    
    
    init?(data: Data) {
        #if os(iOS)
        guard let uiImage = UIImage(data: data) else { return nil }
        self.init(uiImage: uiImage)
        #elseif os(macOS)
        guard let nsImage = NSImage(data: data) else { return nil }
        self.init(nsImage: nsImage)
        #endif
    }
}


extension View {
    
    func `if`<V: View>(_ condition: Bool, apply: (Self) -> V) -> some View {
        if condition {
            return AnyView(apply(self))
        } else {
            return AnyView(self)
        }
    }
    
    
    func hideNavigationBar() -> some View {
        #if os(iOS)
        return self.navigationBarHidden(true)
        #elseif os(macOS)
        return self
        #endif
    }
    
    
    func leadingNavigationBarItems<V: View>(_ items: V) -> some View {
        #if os(iOS)
        return self.navigationBarItems(leading: items)
        #elseif os(macOS)
        return self
        #endif
    }
    
    
    func geometryReader() -> some View {
        let geometryReader = GeometryReader { geometry -> AnyView in
            #if DEBUG
            print(geometry.size)
            #endif
            return AnyView(Rectangle().fill(Color.clear))
        }
        return background(geometryReader)
    }
    
    
    func autocapitalizationWithWords() -> some View {
        #if os(iOS)
        return self.autocapitalization(.words)
        #elseif os(macOS)
        return self
        #endif
    }
}


#if canImport(UIKit)
extension UIApplication {
    
    static func hideKeyboard() {
        shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif


extension String {
    var localized: LocalizedStringKey { LocalizedStringKey(self) }
}


extension Color {
    static let placeholder = Color("PlaceholderColor")
}


#if os(macOS)
extension NSColor {
    static let accentColor = NSColor(named: "AccentColor")!
}
#endif
