//
//  SampleControlStyle.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleControlStyle: View {
    @State private var gaugeValue = 0.9
    @State private var sliderValue = 0.6
    @State private var pickerValue = "Option 1"
    @State private var tintType = "Color"
    @State private var tintColor = Color.orange
    @State private var tintShapeStyle = LinearGradient(
        colors: [.indigo, .purple, .orange, .red, .red],
        startPoint: .leading,
        endPoint: .trailing
    )
    @State private var labelsHidden = false
    @State private var controlSize = ControlSize.regular
    
    var body: some View {
        Form {
            controls
            
            Section("色调") {
                Picker("tint", selection: $tintType) {
                    Text("Color").tag("Color")
                    Text("ShapeStyle").tag("ShapeStyle")
                }
            }
            
            Section("隐藏标签") {
                Toggle("labelsHidden", isOn: $labelsHidden)
            }
            
            Section("尺寸") {
                Picker("ControlSize", selection: $controlSize) {
                    ForEach(ControlSize.allCases, id: \.self) {
                        Text($0.description)
                    }
                }
            }
        }
        .tint(
            LinearGradient(
                colors: [.indigo, .purple, .orange, .red, .red],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .formStyle(.grouped)
    }
    
    @ViewBuilder private var controls: some View {
        let controls = Section {
            HStack {
                Button("Button") {}
                    .bold()
                
                Button("Button") {}
                    .buttonStyle(.borderedProminent)
            }
            
            ProgressView()
            
            Slider(value: $sliderValue) {
                Text("Slider label")
            }
            
            Gauge(value: gaugeValue) {
                Text("Gauge label")
            }
            .gaugeStyle(.linearCapacity)
            
            Picker("Picker label", selection: $pickerValue) {
                Text("Option 1").tag("Option 1")
                Text("Option 2").tag("Option 2")
            }
        }
        
        
        let group = Group {
            switch tintType {
            case "Color":
                controls.tint(tintColor)
            case "ShapeStyle":
                controls.tint(tintShapeStyle)
            default:
                controls
            }
        }
        
        Group {
            if labelsHidden {
                group.labelsHidden()
            } else {
                group
            }
        }
        .controlSize(controlSize)
    }
}

extension ControlSize: CustomStringConvertible {
    public var description: String {
        switch self {
        case .mini:
            return ".mini"
        case .small:
            return ".small"
        case .regular:
            return ".regular"
        case .large:
            return ".large"
        @unknown default:
            return "Unknown"
        }
    }
}

struct SampleControlStyle_Previews: PreviewProvider {
    static var previews: some View {
        SampleControlStyle()
    }
}

