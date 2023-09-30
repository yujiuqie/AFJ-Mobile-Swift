//
//  SampleLayoutSize.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/20.
//

import SwiftUI

struct SampleLayoutSize: View {
    
    var body: some View {
        Form {
            Section("padding") {
                PaddingView()
            }
            .textCase(nil)
            
            Section("frame") {
                FrameView()
            }
            .textCase(nil)
            
            Section("fixedSize") {
                FixedSizeView()
            }
            .textCase(nil)
            
            Section("layoutPriority") {
                LayoutPriorityView()
            }
            .textCase(nil)
        }
        .formStyle(.grouped)
    }
}

fileprivate struct PaddingView: View {
    @State private var padding: CGFloat = 10.0
    
    var body: some View {
        VStack {
            LabeledContent(".padding(\(padding, specifier: "%.1f"))") {
                Text("Hello")
                    .border(.primary)
                    .padding(padding)
                    .border(.red)
            }
            Slider(value: $padding, in: 0...20) {
                Text("padding")
            }
        }
    }
}


fileprivate struct FrameView: View {
    @State private var minWidth: CGFloat = 50
    @State private var maxWidth: CGFloat = 70
    @State private var minHeight: CGFloat = 30
    @State private var maxHeight: CGFloat = 50
    
    var body: some View {
        LabeledContent("固定 frame") {
            Text("Hello")
                .frame(width: 60, height: 40, alignment: .topLeading)
                .border(.red)
        }
        VStack {
            LabeledContent("动态 frame") {
                Text("Hello World")
                    .frame(
                        minWidth: minWidth,
                        maxWidth: maxWidth,
                        minHeight: minHeight,
                        maxHeight: maxHeight
                    )
                    .border(.red)
            }
            LabeledContent("minWidth: \(minWidth, specifier: "%.1f")") {
                Slider(value: $minWidth, in: 30...60)
            }
            LabeledContent("maxWidth: \(maxWidth, specifier: "%.1f")") {
                Slider(value: $maxWidth, in: 60...120)
            }
            LabeledContent("minHeight: \(minHeight, specifier: "%.1f")") {
                Slider(value: $minHeight, in: 20...30)
            }
            LabeledContent("maxHeight: \(maxHeight, specifier: "%.1f")") {
                Slider(value: $maxHeight, in: 30...50)
            }
        }
    }
}

fileprivate struct FixedSizeView: View {
    @State private var fixedSize1 = false
    @State private var fixedSize2 = false
    
    var body: some View {
        LabeledContent {
            Toggle("fixedSize", isOn: $fixedSize1)
                .labelsHidden()
        } label: {
            if fixedSize1 {
                Text("Hello World")
                    .fixedSize()
                    .frame(minWidth: 30, maxWidth: 50, maxHeight: 30)
                    .border(.red)
            } else {
                Text("Hello World")
                    .frame(minWidth: 30, maxWidth: 50, maxHeight: 30)
                    .border(.red)
            }
        }
        
        LabeledContent {
            Toggle("fixedSize", isOn: $fixedSize2)
                .labelsHidden()
        } label: {
            if fixedSize2 {
                Text("Hello World")
                    .frame(minWidth: 50, idealWidth: 100,
                           maxWidth: 150, maxHeight: 30)
                    .fixedSize()
                    .border(.red)
            } else {
                Text("Hello World")
                    .frame(minWidth: 50, idealWidth: 100,
                           maxWidth: 150, maxHeight: 30)
                    .border(.red)
            }
        }
    }
}

fileprivate struct LayoutPriorityView: View {
    @State private var layoutPriority = false
    
    var body: some View {
        HStack(spacing: 15) {
            Group {
                Text("Left")
                if layoutPriority {
                    Text("Stay Hungry, Stay Foolish")
                        .layoutPriority(1)
                } else {
                    Text("Stay Hungry, Stay Foolish")
                }
                Text("Right")
            }
            .border(.blue)
        }
        .frame(width: 225, height: 30)
        .border(.red)
        
        Toggle(".layoutPriority(1)", isOn: $layoutPriority)
    }
}


struct SampleLayoutSize_Previews: PreviewProvider {
    static var previews: some View {
        SampleLayoutSize()
    }
}

