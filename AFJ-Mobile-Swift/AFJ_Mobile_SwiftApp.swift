//
//  AFJ_Mobile_SwiftApp.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/16.
//

import SwiftUI

@main
struct AFJ_Mobile_SwiftApp: App {
    
    @UIApplicationDelegateAdaptor private var uiAppDelegate: UIAppDelegate
    
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(appState)
        }
    }
}
