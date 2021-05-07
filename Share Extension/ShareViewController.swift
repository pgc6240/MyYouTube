//
//  ShareViewController.swift
//  Share Extension
//
//  Created by pgc6240 on 07.05.2021.
//

import Social

final class ShareViewController: SLComposeServiceViewController {
    
    @UserDefault(userDefaults: .myYouTube, key: Keys.shared, defaultValue: false) private var shared: Bool
    @UserDefault(userDefaults: .myYouTube, key: Keys.sharedURL, defaultValue: nil) private var sharedURL: URL?
    

    override func didSelectPost() {
        shared = true
        sharedURL = URL(string: contentText)
        if let url = URL(string: "myYouTube://") {
            openURL(url)
        }
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    
    @discardableResult @objc private func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
}
