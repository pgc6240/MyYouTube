//
//  PageControl.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

protocol PageControlDelegate {
    func goToPage(with pageToken: String)
}

struct PageControl: View {
    
    let delegate: PageControlDelegate
    @ObservedObject var dataSource: VideoLoader
    @State private var currentPage = 1
    @State private var pageTokens: [Int: String] = [1: ""]
    @State private var key = ""
    
    var body: some View {
        HStack(spacing: 5) {
            prevPageButton
            Divider()
            ForEach(pageTokens.sorted(by: <), id: \.key) { page, pageToken in
                if page >= currentPage - 3 && page <= currentPage + 3 {
                    Text("\(page)")
                        .font(page == currentPage ? Font.body.bold() : .body)
                        .onTapGesture { goToPage(page: page) }
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }
            }
            Divider()
            nextPageButton
        }
        .frame(maxWidth: .infinity)
        .onReceive(dataSource.$pageInfos, perform: savePageInfo)
    }
}


//MARK: - Subviews -
private extension PageControl {
    
    var prevPageButton: some View {
        Button(action: goToPrevPage) {
            HStack(spacing: 5) {
                Image(systemName: Images.back).font(Font.body.bold())
                Text("Prev page")
            }
        }
        .buttonStyle(BorderlessButtonStyle())
        .foregroundColor(.accentColor)
        .disabled(prevPageUnvailable)
        .layoutPriority(1)
    }
    
    var nextPageButton: some View {
        Button(action: goToNextPage) {
            HStack(spacing: 5) {
                Text("Next page")
                Image(systemName: Images.forward).font(Font.body.bold())
            }
        }
        .buttonStyle(BorderlessButtonStyle())
        .foregroundColor(.accentColor)
        .disabled(nextPageUnavailable)
        .layoutPriority(1)
    }
}


//MARK: - Methods -
private extension PageControl {
    
    var prevPageUnvailable: Bool {
        pageTokens[currentPage - 1] == nil
    }
    
    
    var nextPageUnavailable: Bool {
        pageTokens[currentPage + 1] == nil || dataSource.pageInfos[key]?.resultsPerPage == 0
    }
    
    
    func savePageInfo(_ pageInfos: [String: PageInfo]) {
        guard let pageInfo = pageInfos.first else { return }
        pageTokens[currentPage + 1] = pageInfo.value.nextPageToken
        pageTokens[currentPage - 1] = pageInfo.value.prevPageToken
        key = pageInfo.key
    }
    
    
    func goToPrevPage() {
        goToPage(page: currentPage - 1)
    }
    
    
    func goToNextPage() {
        guard pageTokens[currentPage + 1] != nil && dataSource.pageInfos[key]?.resultsPerPage != 0 else { return }
        goToPage(page: currentPage + 1)
    }
    
    
    func goToPage(page: Int) {
        guard page != currentPage, let pageToken = pageTokens[page] else { return }
        currentPage = page
        delegate.goToPage(with: pageToken)
    }
}
