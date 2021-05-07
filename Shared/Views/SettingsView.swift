//
//  SettingsView.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var settings: Settings
    @State private var region: Region = .RU
    @State private var displayDescription = true
    @State private var showChangingLanguageAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                languagePicker
                displayDescriptionToggle
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    closeButton
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: saveSettings).padding()
                }
            }
        }.onAppear(perform: getSettings)
    }
}


//MARK: - Subviews -
private extension SettingsView {
    
    var languagePicker: some View {
        Picker("Language & region:", selection: $region) {
            ForEach(Region.allCases, id: \.self) { region in
                Text(region.description).tag(region)
            }
        }
        .onChange(of: region) { _ in showChangingLanguageAlert = true }
        .alert(isPresented: $showChangingLanguageAlert) {
            let message: LocalizedStringKey = "Language will be changed after app relaunch."
            return Alert(title: Text(message), message: nil, dismissButton: .default(Text("OK")))
        }
    }
    
    var displayDescriptionToggle: some View {
        Toggle("Display video description", isOn: $displayDescription).toggleStyle(SwitchToggleStyle(tint: .red))
    }
    
    var closeButton: some View {
        Text("Close")
            .padding([.vertical, .trailing])
            .foregroundColor(.black)
            .onTapGesture(perform: close)
    }
}


//MARK: - Internal methods -
private extension SettingsView {
    
    func getSettings() {
        region             = settings.region
        displayDescription = settings.displayDescription
    }
    
    
    func setSettings() {
        if settings.region != region {
            settings.regionChanged(to: region)
        }
        
        settings.region             = region
        settings.displayDescription = displayDescription
    }
    
    
    func saveSettings() {
        setSettings()
        DispatchQueue.main.async {
            close()
        }
    }
    
    
    func close() {
        presentationMode.wrappedValue.dismiss()
    }
}
