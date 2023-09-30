//
//  SampleDatePicker.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleDatePicker: View {
    @State private var selection = Date()
    @State private var datePickerType = DatePickerType.automatic
    @State private var componentsSelection = 0
    private var components: DatePickerComponents {
        switch componentsSelection {
        case 0: return [.date]
        case 1: return [.hourAndMinute]
        case 2: return [.date, .hourAndMinute]
        default: return [.date, .hourAndMinute]
        }
    }
    
    var body: some View {
        Form {
            datePicker
            
            Picker(".datePickerStyle", selection: $datePickerType) {
                ForEach(DatePickerType.allCases, id: \.self) {
                    Text($0.description)
                }
            }
            
            Picker("displayedComponents", selection: $componentsSelection) {
                Text("[.date]").tag(0)
                Text("[.hourAndMinute]").tag(1)
                Text("[.date, .hourAndMinute]").tag(2)
            }
        }
        .formStyle(.grouped)
    }
    
    @ViewBuilder private var datePicker: some View {
        let picker = DatePicker(
            "Date",
            selection: $selection,
            in: Date()..., // 可选
            displayedComponents: components // 可选
        )
        switch datePickerType {
        case .automatic:
            picker.datePickerStyle(.automatic)
        case .compact:
            picker.datePickerStyle(.compact)
        case .graphical:
            picker.datePickerStyle(.graphical)
#if os(iOS)
        case .wheel:
            picker.datePickerStyle(.wheel)
                .labelsHidden()
#else
        case .field:
            picker.datePickerStyle(.field)
        case .stepperField:
            picker.datePickerStyle(.stepperField)
#endif
        }
    }
}

fileprivate enum DatePickerType:
    String, CaseIterable, CustomStringConvertible {
    case automatic
    case compact
    case graphical
#if os(iOS)
    case wheel
#else
    case field
    case stepperField
#endif
    
    var description: String {
        ".\(rawValue)"
    }
}

struct SampleDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        SampleDatePicker()
    }
}

