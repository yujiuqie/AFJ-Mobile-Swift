//
//  SampleSlider.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleSlider: View {
    @State private var value1 = 0.5
    
    @State private var value2 = 0.0
    @State private var range2 = -20.0...20.0
    
    @State private var isEditing = false
    
    var body: some View {
        Form {
            Section {
                Slider(value: $value1) { isEditing in
                    self.isEditing = isEditing
                }
                .tint(.red)
                Text("value: \(value1)")
                Text("format value: \(value1, specifier: "%.1f")")
            }
            
            Section {
                Slider(
                    value: $value2,
                    in: range2,
                    step: 10
                ) {
                    Text("Value: \(value2, specifier: "%.1f")")
                } minimumValueLabel: {
                    Text("\(range2.lowerBound, specifier: "%.1f")")
                } maximumValueLabel: {
                    Text("\(range2.upperBound, specifier: "%.1f")")
                } onEditingChanged: { isEditing in
                    self.isEditing = isEditing
                }
            }
            
            Section {
                HStack {
                    Text("Editing")
                    Image(systemName: "circle.fill")
                        .foregroundColor(isEditing ? .green : .red)
                }
            }
        }
        .formStyle(.grouped)
    }
}

struct SampleSlider_Previews: PreviewProvider {
    static var previews: some View {
        SampleSlider()
    }
}

