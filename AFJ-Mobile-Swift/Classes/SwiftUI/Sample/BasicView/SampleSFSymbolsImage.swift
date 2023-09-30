//
//  SampleSFSymbolsImage.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleSFSymbolsImage: View {
    @State private var imageScale: Image.Scale = .large
    @State private var renderingMode: RenderingMode = .hierarchical
    @State private var isRendering = false
    @State private var foregroundStyle: ForegroundStyle = .two
    @State private var scaleEffect: CGFloat = 1.0
    @State private var fontSize: CGFloat = 25
    @State private var isVariable = false
    @State private var variableValue: Double = 0.5
    
    var body: some View {
        Form {
            image
                .imageScale(imageScale)
                .scaleEffect(scaleEffect)
                .font(.system(size: fontSize))
                .padding(30)
                .frame(maxWidth: .infinity)
            
            Section("Dimension") {
                Picker(".imageScale", selection: $imageScale) {
                    ForEach(Image.Scale.allCases, id: \.self) {
                        Text($0.description)
                    }
                }
                
                LabeledContent(".scaleEffect\n\(scaleEffect.formatted())") {
                    Slider(value: $scaleEffect, in: 1.0...2.0)
                }
                
                LabeledContent("fontSize\n\(fontSize.formatted())") {
                    Slider(value: $fontSize, in: 25...40)
                }
            }
            .textCase(nil)
            
            Section("Style") {
                Picker(".foregroundStyle", selection: $foregroundStyle) {
                    ForEach(ForegroundStyle.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                
                VStack {
                    Toggle("Rendering", isOn: $isRendering.animation())
                    if isRendering {
                        Picker("RenderingMode", selection: $renderingMode) {
                            ForEach(RenderingMode.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .transition(.opacity)
                    }
                }
                
                VStack {
                    Toggle("Variable", isOn: $isVariable.animation())
                    if isVariable {
                        LabeledContent("value\n\(variableValue.formatted())") {
                            Slider(value: $variableValue, in: 0.0...1.0)
                        }
                        .transition(.opacity)
                    }
                }
            }
            .textCase(nil)
        }
        .formStyle(.grouped)
    }
    
    @ViewBuilder var image: some View {
        let images =
        HStack(spacing: 15) {
            ForEach([
                "touchid",
                "wifi",
                "mic.and.signal.meter",
            ], id: \.self) {
                Image(
                    systemName: $0,
                    variableValue: isVariable ? variableValue : nil
                )
            }
        }
        .animation(.default, value: variableValue) // 增加动画，更平滑
        
        let group =
        Group {
            if isRendering {
                images.symbolRenderingMode(renderingMode.value)
            } else {
                images
            }
        }
        
        let colors = foregroundStyle.colors
        switch foregroundStyle {
        case .one:
            group.foregroundStyle(colors[0])
        case .two:
            group.foregroundStyle(colors[0], colors[1])
        }
    }
}

fileprivate enum ForegroundStyle: String, CaseIterable {
    case one = "one (.blue)"
    case two = "two (.blue, .red)"
    
    var colors: [Color] {
        switch self {
        case .one:
            return [.blue]
        case .two:
            return [.blue, .red]
        }
    }
}

fileprivate enum RenderingMode: String, CaseIterable {
    case hierarchical = "hierarchical"
    case monochrome = "monochrome"
    case multicolor = "multicolor"
    case palette = "palette"
    
    var value: SymbolRenderingMode {
        switch self {
        case .hierarchical:
            return .hierarchical
        case .monochrome:
            return .monochrome
        case .multicolor:
            return .multicolor
        case .palette:
            return .palette
        }
    }
}

extension Image.Scale: CaseIterable, CustomStringConvertible {
    public static var allCases: [Image.Scale] {
        [.large, .medium, .small]
    }
    
    public var description: String {
        switch self {
        case .small:
            return ".small"
        case .medium:
            return ".medium"
        case .large:
            return ".large"
        @unknown default:
            return "unknown"
        }
    }
}

struct SampleSFSymbolsImage_Previews: PreviewProvider {
    static var previews: some View {
        SampleSFSymbolsImage()
    }
}

