//
//  SampleViewsLife.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/20.
//

import SwiftUI

struct SampleViewsLife: View {
    
    @State private var text = "Hello"
    @State private var id = 1
    @State private var isOn = false
    @State private var cornerRadius: CGFloat = 10
    
    var body: some View {
        VStack(spacing: 20) {
            Text(text)
                .font(.title)
                .padding()
                .background(.purple)
                .cornerRadius(cornerRadius)
                .id(id)
            
            Toggle("改变视图 id", isOn: $isOn)
                .fixedSize()
            
            Button("执行动画") {
                withAnimation(.easeInOut(duration: 1)) {
                    if isOn { id += 1 }
                    text = (text == "Hello") ? "Hello, I'm Bruce" : "Hello"
                    cornerRadius = (cornerRadius == 10) ? 30 : 10
                }
            }
        }
        .padding()
    }
}

