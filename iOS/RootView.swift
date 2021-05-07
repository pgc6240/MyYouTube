//
//  RootView.swift
//  MyYouTube (iOS)
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct RootView: View {
    
    @AppStorage(Keys.selectedTab) private var selectedTab = Tab.main
    @EnvironmentObject private var networkManager: NetworkManager
    
    var body: some View {
        if networkManager.networkIsUnavailable {
            NetworkUnavailableView()
        }
        TabView(selection: $selectedTab) {
            NavigationView {
                MainView()
                    .navigationBarTitle(Text(Tab.main.title), displayMode: .inline)
                    .playerBar()
            }
            .tabItem { Label(Tab.main.title, systemImage: Tab.main.icon) }
            .tag(Tab.main)
            
            NavigationView {
                MyTimeStamps()
                    .navigationTitle(Tab.myTimeStamps.title)
                    .playerBar()
            }
            .tabItem { Label(Tab.myTimeStamps.title, systemImage: Tab.myTimeStamps.icon) }
            .tag(Tab.myTimeStamps)
            
            NavigationView {
                VideoFeed()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(leading: appIcon, trailing: subscriptionsButton)
                    .playerBar()
            }
            .tabItem { Label(Tab.videoFeed.title, systemImage: Tab.videoFeed.icon) }
            .tag(Tab.videoFeed)
        }
    }
}


// MARK: - Subviews -
private extension RootView {
    
    var appIcon: some View {
        HStack(spacing: 2) {
            Text("My")
            Image(systemName: Images.appIcon)
                .foregroundColor(.accentColor)
                .saturation(0.9)
        }
    }
    
    var subscriptionsButton: some View {
        NavigationLink(destination: Subscriptions()
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarBackButtonHidden(true)
        ) {
            HStack(spacing: 5) {
                Text("My subscriptions").font(.body)
                Image(systemName: Images.forward).font(Font.body.bold())
            }
            .foregroundColor(.accentColor)
            .padding([.leading, .vertical])
        }
    }
}
