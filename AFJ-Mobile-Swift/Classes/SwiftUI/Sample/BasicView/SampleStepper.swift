//
//  SampleStepper.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleStepper: View {
    @State private var amount1 = 0
    @State private var isEditing = false
    
    @State private var amount2 = 0
    @State private var current = 0
    @State private var state = "0"
    
    var body: some View {
        Form {
            Section {
                Stepper("Amount: \(amount1)", value: $amount1) { isEditing in
                    self.isEditing = isEditing
                }
            } footer: {
                HStack {
                    Text("长按增减按钮进行加速")
                }
            }
            
            Section {
                Stepper {
                    Text("Amout: \(amount2)")
                } onIncrement: {
                    current = (0...10).randomElement()!
                    state = "+\(current)"
                    amount2 += current
                } onDecrement: {
                    current = -(1...10).randomElement()!
                    state = "-\(current)"
                    amount2 += current
                } onEditingChanged: { isEditing in
                    self.isEditing = isEditing
                }
            } footer: {
                HStack {
                    Text("State: \(current)")
                    Text(current == 0 ? "💪" : current > 0 ? "👏" : "😿")
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

struct SampleStepper_Previews: PreviewProvider {
    static var previews: some View {
        SampleStepper()
    }
}

