//
//  SamplePreferredColorScheme.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SamplePreferredColorScheme: View {
    @State private var preferredColorScheme: ColorScheme = .light
    
    var body: some View {
        Form {
            Text("Hello, World!")
                .padding()
                .background(.regularMaterial)
                .cornerRadius(10)
                .shadow(radius: 10)
                .preferredColorScheme(preferredColorScheme)
            
            Picker("colorScheme", selection: $preferredColorScheme) {
                Text("Light").tag(ColorScheme.light)
                Text("Dark").tag(ColorScheme.dark)
            }
        }
        .formStyle(.grouped)
    }
}

struct SamplePreferredColorScheme_Previews: PreviewProvider {
    static var previews: some View {
        SamplePreferredColorScheme()
    }
}

