//
//  SampleMultiDatePicker.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

#if os(iOS)
struct SampleMultiDatePicker: View {
    @State private var selection: Set<DateComponents> = []
    private var dates: [Date] {
        Array(selection).compactMap { $0.date }.sorted()
    }
    
    var body: some View {
        Form {
            Section {
                MultiDatePicker("Dates", selection: $selection)
            } footer: {
                LabeledContent("已选日期") {
                    VStack(alignment: .trailing) {
                        ForEach(dates, id: \.self) {
                            Text($0, format: .dateTime)
                        }
                    }
                }
            }
        }
        .formStyle(.grouped)
    }
}
#endif

struct SampleMultiDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        SampleMultiDatePicker()
    }
}

