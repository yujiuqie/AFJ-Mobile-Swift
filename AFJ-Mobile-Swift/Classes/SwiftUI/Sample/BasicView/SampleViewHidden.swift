//
//  SampleViewHidden.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleViewHidden: View {
    @State private var opacity: Double = 1.0
    @State private var hidden = false
    @State private var show = true
    
    var body: some View {
        Form {
            Section("显示与隐藏") {
                GroupBox("") {
                    HiddenView {
                        middleView.opacity(opacity)
                    }
                    LabeledContent {
                        Slider(value: $opacity, in: 0.0...1.0)
                    } label: {
                        Text("opacity: \(opacity, specifier: "%.1f")")
                    }
                }
                
                GroupBox("") {
                    HiddenView {
                        middleView.if(hidden) { view in
                            view.hidden()
                        }
                    }
                    Toggle(".hidden()", isOn: $hidden.animation())
                }
                
                GroupBox("") {
                    HiddenView {
                        if show {
                            middleView
                        }
                    }
                    Toggle("条件渲染", isOn: $show.animation())
                }
            }
            
            Section("隐藏敏感信息") {
                AppleCard()
            }
        }
        .formStyle(.grouped)
    }
    
    private var middleView: some View {
        Image(systemName: "signpost.right.and.left")
    }
}

fileprivate struct AppleCard: View {
    @State private var sensitive = true
    @State private var redacted = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(systemName: "applelogo")
                    Text("Apple Card")
                }
                .font(.title3)
                .bold()
                .opacity(0.6)
                
                Text(12345.678, format: .currency(code: "USD"))
                    .frame(maxWidth: .infinity)
                    .font(.title)
                    .bold()
                    .monospaced()
                    .padding()
                    .redacted(reason: redacted ? .placeholder : [])
                
                HStack {
                    Text("\(Image(systemName: "person.fill")) zzzwco")
                        .unredacted()
                    Spacer()
                    Text("No. 0942070109")
                        .monospaced()
                }
                .foregroundColor(.secondary)
                .privacySensitive(sensitive)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background(
                LinearGradient(
                    colors: [.purple, .blue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
                .blur(radius: 50)
            )
            .cornerRadius(15)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.primary.opacity(0.15))
            }
            
            Group {
                Toggle("redacted(placeholer)", isOn: $redacted.animation())
                Toggle("sensitive", isOn: $sensitive.animation())
                if sensitive {
                    Text("试试在 iOS 下拉通知中心，或者缓慢使用手势挂起程序")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                        .transition(.opacity)
                }
            }
        }
        .padding(.vertical)
    }
}

fileprivate struct HiddenView<C: View>: View {
    private let middleView: () -> C
    
    init(@ViewBuilder middleView: @escaping () -> C) {
        self.middleView = middleView
    }
    
    var body: some View {
        HStack {
            Image(systemName: "arrowshape.left")
            middleView()
            Image(systemName: "arrowshape.right")
        }
        .font(.title)
        .foregroundColor(.blue)
        .padding()
        .frame(maxWidth: .infinity)
    }
}

struct SampleViewHidden_Previews: PreviewProvider {
    static var previews: some View {
        SampleViewHidden()
        //      .preferredColorScheme(.dark)
    }
}

