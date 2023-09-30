//
//  SampleColor.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleColor: View {
    private let standardColors: [Color] = [
        .black,
        .blue,
        .brown,
        .clear,
        .cyan,
        .gray,
        .green,
        .indigo,
        .mint,
        .orange,
        .pink,
        .purple,
        .red,
        .teal,
        .white,
        .yellow,
    ]
    
    private let semanticColors: [Color] = [
        .accentColor,
        .primary,
        .secondary,
    ]
    
    @State private var opacity: Double = 1.0
    @State private var isGradient = false
    
    var body: some View {
        Form {
            Section("标准颜色") {
                colorsView(colors: standardColors)
            }
            
            Section("语义化颜色") {
                colorsView(colors: semanticColors)
            }
        }
        .formStyle(.grouped)
        .safeAreaInset(edge: .bottom) {
            VStack(alignment: .leading) {
                Toggle("gradient", isOn: $isGradient)
                Divider()
                Slider(value: $opacity) {
                    Text("opacity")
                }
            }
            .padding()
            .background(.bar)
        }
    }
    
    @ViewBuilder func colorsView(
        colors: [Color]
    ) -> some View {
        ForEach(colors, id: \.self) { color in
            LabeledContent {
                if isGradient {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color.gradient.opacity(opacity))
                        .frame(height: 44)
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color.opacity(opacity))
                        .frame(height: 44)
                }
            } label: {
                Text(color == .accentColor
                     ? "accentColor"
                     : color.description
                )
                .frame(width: 120)
            }
        }
    }
}

struct SampleColor_Previews: PreviewProvider {
    static var previews: some View {
        SampleColor()
    }
}

