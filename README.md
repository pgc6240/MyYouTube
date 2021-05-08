# MyYouTube
With the app you can search YouTube videos and channels, play videos (including in background), time stamp, subscribe channels and other. Stamped videos saved to a list in separate tab, where you can delete or order videos in the manner you like.

### Key features:
* Time stamp YouTube videos
* Subcribe YouTube channel w/o authorization
* Play videos in background

Video feed|Player view|Subscriptions
-|-|-
![VideoFeed](/Screenshots/VideoFeed+PlayerBar.png) | ![PlayerView](/Screenshots/PlayerView.png) | ![Subscriptions](/Screenshots/Subscriptions.png)

## Concepts used:
* SwiftUI
* MVVM
* Combine for networking
* No 3rd party libraries
* Share Extension
* Russian / English languages
* Multiplatform (iOS and macOS)
  
### `Some other:`  
_Error Handling, Edge Cases_  
_State Restoration, Infinite Scrolling_  
_Delegation, Singleton, Builder, Flyweight, Observer, Strategy_  
_GCD, UserDefaults, Codable, UI/NSViewRepresentable, URLCache_  
_SOLID_  

#### DISCLAIMER!
> The project on GitHub missing a valid API key. To test the app you need to get an YouTube Data API key, which you can set in Constants.swift file located in Shared/Utilities folder like this:
> ```swift
> enum Constants {
>   static let API_KEY = "[YOUR_API_KEY]"
> }
> ```
