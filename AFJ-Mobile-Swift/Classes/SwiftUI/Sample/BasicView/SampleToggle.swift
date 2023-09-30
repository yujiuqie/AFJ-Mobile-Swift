//
//  SampleToggle.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleToggle: View {
    @State private var isOn = true
    @State private var tint: Color = .accentColor
    @State private var toggleType: ToggleType = .automatic
    
    @State private var options = [
        OptionData(isOn: true, name: "option 1"),
        OptionData(isOn: false, name: "option 2"),
        OptionData(isOn: true, name: "option 3")
    ]
    
    @State private var isMark = false
    @State private var markOptions = [
        OptionData(isOn: true, name: "option 1"),
        OptionData(isOn: false, name: "option 2"),
        OptionData(isOn: true, name: "option 3")
    ]
    
    var body: some View {
        Form {
            Section("单值开关") {
                toggle
                    .tint(tint)
                
                if isOn {
                    ColorPicker("tint", selection: $tint)
                }
                
                Picker(".toggleStyle", selection: $toggleType) {
                    ForEach(ToggleType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
            }
            
            Section("多值开关") {
                Toggle(sources: $options, isOn: \.isOn) {
                    Text("全选")
                }
                ForEach(options) { option in
                    LabeledContent(option.name) {
                        Image(systemName: "checkmark.circle.fill")
                            .opacity(option.isOn ? 1 : 0)
                            .foregroundColor(.accentColor)
                    }
                }
            }
            
            Section("自定义开关样式") {
                Toggle(isMark ? "On" : "Off", isOn: $isMark)
                    .toggleStyle(.mark)
            }
            
            Section {
                Toggle(sources: $markOptions, isOn: \.isOn) {
                    Text("全选")
                }
                .toggleStyle(.mark)
                
                ForEach(markOptions) { option in
                    LabeledContent(option.name) {
                        Image(systemName: "checkmark.circle.fill")
                            .opacity(option.isOn ? 1 : 0)
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
        .formStyle(.grouped)
    }
    
    @ViewBuilder private var toggle: some View {
        let toggle = Toggle(
            isOn ? "On" : "Off",
            isOn: $isOn.animation()
        )
        
        switch toggleType {
        case .automatic:
            toggle.toggleStyle(.automatic)
        case .button:
            toggle.toggleStyle(.button)
        case .switch:
            toggle.toggleStyle(.switch)
#if os(macOS)
        case .checkbox:
            toggle.toggleStyle(.checkbox)
#endif
        }
    }
}

fileprivate struct OptionData: Hashable, Identifiable {
    let id = UUID()
    var isOn = false
    var name = ""
}

fileprivate enum ToggleType: String, CaseIterable {
    case automatic = "automatic"
    case button = "button"
    case `switch` = "swich"
#if os(macOS)
    case checkbox = "checkbox"
#endif
}

fileprivate struct MarkToggleStyle: ToggleStyle {
    @Namespace private var icon
    
    func makeBody(configuration: Configuration) -> some View {
        let isOn = configuration.isOn
        let isMixed = configuration.isMixed
        
        let bgColor: Color = isMixed
        ? .yellow
        : isOn ? .green : .red
        
        HStack {
            configuration.label
            Spacer()
            Capsule()
                .foregroundColor(bgColor)
                .frame(width: 56, height: 32)
                .overlay(
                    icon(isMixed: isMixed, isOn: isOn)
                )
                .animation(.spring(), value: configuration.isOn)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
    
    @ViewBuilder private func icon(
        isMixed: Bool,
        isOn: Bool
    ) -> some View {
        if isMixed {
            image(name: "togglepower", offsetX: 0)
        } else {
            if isOn {
                image(name: "checkmark.circle.fill", offsetX: 12)
            } else {
                image(name: "xmark.circle.fill", offsetX: -12)
            }
        }
    }
    
    @ViewBuilder private func image(
        name: String,
        offsetX: CGFloat
    ) -> some View {
        Image(systemName: name)
            .resizable()
            .frame(width: 20, height: 20)
            .matchedGeometryEffect(id: "icon", in: icon)
            .offset(x: offsetX)
            .foregroundColor(.white)
    }
}

extension ToggleStyle where Self == MarkToggleStyle {
    static var mark: Self { .init() }
}

struct SampleToggle_Previews: PreviewProvider {
    static var previews: some View {
        SampleToggle()
            .preferredColorScheme(.dark)
    }
}

