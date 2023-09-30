//
//  SampleLayoutPosition.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/20.
//

import SwiftUI

struct SampleLayoutPosition: View {
    
    var body: some View {
        Form {
            Section("Spacer") {
                SpacerView()
            }
            .textCase(nil)
            
            Section("Divider") {
                DividerView()
            }
            .textCase(nil)
            
            Section("position") {
                PositionView()
            }
            .textCase(nil)
            
            Section("offset") {
                OffsetView()
            }
            .textCase(nil)
        }
        .formStyle(.grouped)
    }
}

fileprivate struct SpacerView: View {
    
    var body: some View {
        HStack {
            Spacer()
            Text("Hello")
        }
        .frame(width: 200)
        .border(.red)
    }
}

fileprivate struct DividerView: View {
    
    var body: some View {
        VStack {
            Divider()
                .frame(height: 2)
                .overlay(.blue)
            HStack {
                Text("Hello")
                Divider()
                Text("World")
            }
            Divider()
                .frame(height: 2)
                .overlay(.blue)
        }
    }
}

fileprivate struct PositionView: View {
    @State private var positionX: CGFloat = 0
    @State private var positionY: CGFloat = 0
    
    var body: some View {
        ZStack {
            Text("Hello")
                .border(.blue)
                .position(x: positionX, y: positionY)
        }
        .frame(width: 100, height: 100)
        .border(.red)
        
        LabeledContent("x: \(positionX, specifier: "%.1f")") {
            Slider(value: $positionX, in: 0...100)
        }
        
        LabeledContent("y: \(positionY, specifier: "%.1f")") {
            Slider(value: $positionY, in: 0...100)
        }
    }
}

fileprivate struct OffsetView: View {
    @State private var offsetX: CGFloat = 0
    @State private var offsetY: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .center) {
            Text("Hello")
                .border(.blue)
                .offset(x: offsetX, y: offsetY)
        }
        .frame(width: 100, height: 100)
        .border(.red)
        
        LabeledContent("x: \(offsetX, specifier: "%.1f")") {
            Slider(value: $offsetX, in: -50...50)
        }
        
        LabeledContent("y: \(offsetY, specifier: "%.1f")") {
            Slider(value: $offsetY, in: -50...50)
        }
    }
}

fileprivate struct CoordinateSpaceView: View {
    
    var body: some View {
        Text("")
    }
}

struct SampleLayoutPosition_Previews: PreviewProvider {
    static var previews: some View {
        SampleLayoutPosition()
    }
}

