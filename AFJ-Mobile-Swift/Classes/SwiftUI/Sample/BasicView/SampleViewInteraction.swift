//
//  SampleViewInteraction.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleViewInteraction: View {
    @State private var isOn = true
    @State private var disableEntireView = false
    @State private var disableToggleOverlay = false
    @State private var buttonOverlayAllowsHitTesting = true
    @State private var events: [String] = []
    
    var body: some View {
        Form {
            Section {
                VStack(spacing: 20) {
                    Text("Hello")
                    
                    Button("Button") {
                        events.append("Tap button")
                    }
#if os(iOS)
                    .buttonStyle(.borderless)
#endif
                    .overlay(
                        Color.blue.opacity(0.2)
                            .onTapGesture {
                                events.append("Tap BUTTON overlay")
                            }
                            .allowsHitTesting(buttonOverlayAllowsHitTesting)
                    )
                    
                    Toggle("On", isOn: $isOn)
                        .onChange(of: isOn) { newValue in
                            events.append("Switch \(newValue ? "ON" : "OFF")")
                        }
                        .overlay(
                            Color.purple.opacity(0.2)
                                .onTapGesture {
                                    events.append("Tap TOGGLE overlay")
                                }
                                .disabled(disableToggleOverlay)
                        )
                }
            }
            .disabled(disableEntireView)
            
            Section {
                Toggle("buttonOverlayAllowsHitTesting", isOn: $buttonOverlayAllowsHitTesting.animation())
                Toggle("disableToggleOverlay", isOn: $disableToggleOverlay.animation())
                Toggle("disableEntireView", isOn: $disableEntireView.animation())
            }
            
            Section("Tap events:") {
                VStack(alignment: .leading) {
                    ForEach(events, id: \.self) {
                        Text($0).font(.footnote).foregroundColor(.secondary)
                    }
                }
            }
            .textCase(nil)
        }
        .formStyle(.grouped)
    }
}

struct SampleViewInteraction_Previews: PreviewProvider {
    static var previews: some View {
        SampleViewInteraction()
    }
}

