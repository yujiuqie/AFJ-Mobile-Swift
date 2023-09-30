//
//  SampleLayoutSafeArea.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/20.
//

import SwiftUI

struct SampleLayoutSafeArea: View {
    
    var body: some View {
        Form {
            Section("ignoresSafeArea") {
                NavigationLink("ignoresSafeArea") {
                    IgnoresSafeAreaView()
                }
            }
            .textCase(nil)
            
            Section("safeAreaInset") {
                NavigationLink("safeAreaInset") {
                    SafeAreaInsetView()
                }
            }
            .textCase(nil)
        }
        .formStyle(.grouped)
    }
}

fileprivate struct IgnoresSafeAreaView: View {
    
    var body: some View {
        Color.orange
            .ignoresSafeArea()
    }
}

fileprivate struct SafeAreaInsetView: View {
    
    var body: some View {
        LinearGradient(
            colors: [.blue, .purple],
            startPoint: .leading,
            endPoint: .trailing
        )
        .ignoresSafeArea()
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button("Left") {}
                Spacer()
                Button("Right") {}
            }
            .padding()
            .background(.bar)
        }
    }
}

struct SampleLayoutSafeArea_Previews: PreviewProvider {
    static var previews: some View {
        SampleLayoutSafeArea()
    }
}

