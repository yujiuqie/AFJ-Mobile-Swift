//
//  SampleTextEditor.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/17.
//

import SwiftUI

struct SampleTextEditor: View {
    @State private var text = ""
    
    var body: some View {
        TextEditor(text: $text)
            .frame(height: 120)
            .overlay(
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1)
                    Text("Type something...")
                        .foregroundColor(.secondary)
                        .opacity(text.isEmpty ? 1 : 0)
#if os(iOS)
                        .offset(x: 12, y: 12)
#else
                        .offset(x: 10, y: 2)
#endif
                }
                    .padding(-5)
            )
            .padding()
    }
}

struct SampleTextEditore_Previews: PreviewProvider {
    static var previews: some View {
        SampleTextEditor()
    }
}

