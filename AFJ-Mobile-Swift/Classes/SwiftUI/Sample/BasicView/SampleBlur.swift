//
//  SampleBlur.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleBlur: View {
    @State private var bgRadius: CGFloat = 0
    @State private var textRadius: CGFloat = 0
    
    var body: some View {
        Form {
            Section(".blur") {
                Text("Hello World")
                    .blur(radius: textRadius)
                    .padding()
                    .background(
                        Capsule()
                            .foregroundColor(.orange)
                            .blur(radius: bgRadius)
                    )
                    .frame(maxWidth: .infinity)
                    .padding()
                    .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                
                GroupBox("background blur") {
                    LabeledContent {
                        Slider(value: $bgRadius, in: 0...100)
                    } label: {
                        Text("radius: \(bgRadius, specifier: "%.1f")")
                    }
                }
                
                GroupBox("text blur") {
                    LabeledContent {
                        Slider(value: $textRadius, in: 0...10)
                    } label: {
                        Text("radius: \(textRadius, specifier: "%.1f")")
                    }
                }
            }
            .textCase(nil)
            
            Section("Material") {
                ZStack {
                    LinearGradient(
                        colors: [.red, .purple],
                        startPoint: .leading,
                        endPoint: .trailing)
                    .cornerRadius(10)
                    
                    VStack {
                        materialView(.ultraThinMaterial, text: ".ultraThinMaterial")
                        materialView(.thin, text: ".thin")
                        materialView(.regular, text: ".regular")
                        materialView(.thick, text: ".thick")
                        materialView(.ultraThick, text: ".ultraThick")
                        materialView(.bar, text: ".bar")
                    }
                    .padding()
                }
                .padding(.vertical)
            }
            .textCase(nil)
        }
        .formStyle(.grouped)
    }
    
    @ViewBuilder func materialView(
        _ material: Material,
        text: String
    ) -> some View {
        VStack {
            Label("Apple", systemImage: "applelogo")
                .padding()
                .background(material)
                .cornerRadius(10)
            
            Text(text)
                .foregroundColor(.primary)
                .font(.footnote)
        }
    }
}

struct SampleBlur_Previews: PreviewProvider {
    static var previews: some View {
        SampleBlur()
    }
}
