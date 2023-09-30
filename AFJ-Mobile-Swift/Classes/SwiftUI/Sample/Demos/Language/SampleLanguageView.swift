//
//  SampleLanguageView.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleLanguageView: View {
    @StateObject private var appState = AppState()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home".localized, systemImage: "house")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings".localized, systemImage: "gear")
                }
        }
        .environmentObject(appState)
    }
}

struct SampleLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        SampleLanguageView()
    }
}
