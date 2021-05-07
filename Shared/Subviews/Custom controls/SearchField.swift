//
//  SearchField.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct SearchField: View {
    
    @EnvironmentObject private var networkManager: NetworkManager
    @Binding private var query: String
    private let placeholder: LocalizedStringKey
    private let onCommit: () -> Void
    private let rounded: Bool
    
    var body: some View {
        TextField(placeholder, text: $query, onCommit: search)
            .if(rounded) {
                $0.textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .disabled(networkManager.networkIsUnavailable)
            .overlay(clearButton, alignment: .trailing)
            .onTapGesture(perform: hideKeyboard)
            .autocapitalizationWithWords()
            .disableAutocorrection(true)
    }
    
    init(_ placeholder: LocalizedStringKey, query: Binding<String>, onCommit: @escaping () -> Void = {}, rounded: Bool = false) {
        self.placeholder = placeholder
        self._query      = query
        self.onCommit    = onCommit
        self.rounded     = rounded
    }
}


// MARK: - Subviews -
private extension SearchField {
    
    var clearButton: some View {
        Button(action: clear) {
            Image(systemName: Images.clear).foregroundColor(.secondary)
        }
        .buttonStyle(BorderlessButtonStyle())
        .padding(.trailing, rounded ? 8 : 0)
        .opacity(query.isEmpty ? 0 : 1)
    }
}


// MARK: - Internal methods -
private extension SearchField {
    
    func search() {
        guard !query.removingWhitespaces.isEmpty else {
            hideKeyboard()
            clear()
            return
        }
        onCommit()
    }
    
    
    func clear() {
        query.removeAll()
    }
    
    
    func hideKeyboard() {
        #if os(iOS)
        UIApplication.hideKeyboard()
        #endif
    }
}
