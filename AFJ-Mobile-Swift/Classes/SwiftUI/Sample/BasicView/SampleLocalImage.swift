//
//  SampleLocalImage.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleLocalImage: View {
    @State private var width: CGFloat = 200
    @State private var height: CGFloat = 200
    @State private var contentMode = ContentMode.fill
    @State private var cornerRadius: CGFloat = 0
    @State private var resizingMode: Image.ResizingMode = .stretch
    @State private var isResizable = true
    @State private var isSmallImage = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.cyan
                
                image
                    .aspectRatio(contentMode: contentMode)
                    .frame(width: width, height: height)
                    .clipShape(
                        RoundedRectangle(cornerRadius: cornerRadius)
                    )
                    .border(Color.purple, width: 3)
            }
            .frame(maxWidth: .infinity)
            
            Form {
                Section("") {
                    VStack {
                        Toggle("resizable", isOn: $isResizable.animation())
                        if isResizable {
                            Picker("resizingMode", selection: $resizingMode) {
                                ForEach(Image.ResizingMode.allCases, id: \.self) {
                                    Text($0.description)
                                }
                            }
                            .transition(.opacity)
                        }
                    }
                    
                    Toggle("小图", isOn: $isSmallImage)
                    
                    Picker("contentMode", selection: $contentMode) {
                        ForEach(ContentMode.allCases, id: \.self) {
                            Text($0.description)
                        }
                    }
                    
                    LabeledContent("width\n\(width.formatted())") {
                        Slider(value: $width, in: 100...375)
                    }
                    
                    LabeledContent("height\n\(height.formatted())") {
                        Slider(value: $height, in: 100...375)
                    }
                    
                    LabeledContent("cornerRadius\n\(cornerRadius.formatted())") {
                        Slider(value: $cornerRadius, in: 0...250)
                    }
                }
            }
            .formStyle(.grouped)
        }
    }
    
    @ViewBuilder var image: some View {
        let image = Image(isSmallImage ? "af-avatar-128" : "af-avatar-512")
        if isResizable {
            image.resizable(resizingMode: resizingMode)
        } else {
            image
        }
    }
}

extension ContentMode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .fill:
            return ".fill"
        case .fit:
            return ".fit"
        }
    }
}

extension Image.ResizingMode: CaseIterable, CustomStringConvertible {
    public static var allCases: [Image.ResizingMode] {
        [.stretch, .tile]
    }
    
    public var description: String {
        switch self {
        case .tile:
            return ".tile"
        case .stretch:
            return ".stretch"
        @unknown default:
            return "unknown"
        }
    }
}

struct SampleLocalImage_Previews: PreviewProvider {
    static var previews: some View {
        SampleLocalImage()
    }
}

