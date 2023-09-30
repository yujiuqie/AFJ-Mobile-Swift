//
//  SampleColorPicker.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleColorPicker: View {
    @State private var supportsOpacity = true
    @State private var color: Color = .accentColor
    
    var body: some View {
        Form {
            ColorPicker(
                selection: $color,
                supportsOpacity: supportsOpacity // 透明度，可选
            ) {
                Text("Color")
                    .foregroundColor(color)
            }
            
            Toggle("supportsOpacity", isOn: $supportsOpacity)
        }
        .formStyle(.grouped)
    }
}

struct SampleColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        SampleColorPicker()
    }
}

