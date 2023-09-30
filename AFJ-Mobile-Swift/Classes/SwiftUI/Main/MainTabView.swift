//
//  MainTabView.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/16.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject private var uiAppDelegate: UIAppDelegate
    
    @State var selectedTabbar = 0
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTabbar) {
                // selection的值,是对应下面tag()内的值的
                MainNavigationView(title: "SwiftUI")
                    .tabItem {
                        Image(systemName: "swift")
                        Text("SwiftUI")
                    }.tag(0)
                TestTempVC(color: .red)
                    .tabItem {
                        Image(systemName: "u.circle")
                        Text("UIKit")
                    }.tag(1)
                MainNavigationView(title: "Founction")
                    .tabItem {
                        Image(systemName: "function")
                        Text("Founction")
                    }.tag(2)
                MainNavigationView(title: "m.circle")
                    .tabItem {
                        Image(systemName: "m.circle")
                        Text("More")
                    }.tag(3)
            }
            .statusBar(hidden: false)
            .foregroundColor(.orange)
            .accentColor(.green)
            .navigationBarHidden(true)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
