//
//  SamplePicker.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SamplePicker: View {
    private let weathers = Weather.mock
    @State private var weather = Weather.mock.last!.name
    @State private var pickerType: PickerType = .automatic
    
    var body: some View {
#if os(iOS)
        form
#else
        VStack {
            picker
                .padding()
            Divider()
            form
        }
#endif
    }
    
    var form: some View {
        Form {
            picker
            stylePicker
        }
        .formStyle(.grouped)
    }
    
    var stylePicker: some View {
        Picker(".pickerStyle", selection: $pickerType) {
            ForEach(PickerType.allCases, id: \.self) {
                Text($0.rawValue)
            }
        }
    }
    
    @ViewBuilder var picker: some View {
        let picker = Picker("Weather", selection: $weather) {
            ForEach(weathers, id: \.name) {
                Label($0.name, systemImage: $0.icon)
            }
        }
        
        switch pickerType {
        case .automatic:
            picker.pickerStyle(.automatic)
        case .inline:
            picker.pickerStyle(.inline)
        case .menu:
            picker.pickerStyle(.menu)
        case .segmented:
            picker.pickerStyle(.segmented)
#if os(iOS)
        case .navigationLink:
            picker.pickerStyle(.navigationLink)
        case .wheel:
            picker.pickerStyle(.wheel)
#elseif os(macOS)
        case .radioGroup:
            picker.pickerStyle(.radioGroup)
#endif
        }
    }
}

fileprivate enum PickerType: String, CaseIterable {
    case automatic = ".automatic"
    case inline = ".inline"
    case menu = ".menu"
    case segmented = ".segmented"
#if os(iOS)
    case navigationLink = ".navigationLink"
    case wheel = ".wheel"
#elseif os(macOS)
    case radioGroup = ".radioGroup"
#endif
}

struct SamplePicker_Previews: PreviewProvider {
    static var previews: some View {
        SamplePicker()
    }
}

