//
//  SampleFonts.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleFonts: View {
    @State private var fontSize: CGFloat = 20
    @State private var monospaced = false
    
    var body: some View {
        Form {
            Section {
                Group {
                    labeledContent(".largeTitle", font: .largeTitle)
                    labeledContent(".title", font: .title)
                    labeledContent(".title2", font: .title2)
                    labeledContent(".title3", font: .title3)
                    labeledContent(".headline", font: .headline)
                    labeledContent(".body", font: .body)
                    labeledContent(".callout", font: .callout)
                }
                Group {
                    labeledContent(".subheadline", font: .subheadline)
                    labeledContent(".footnote", font: .footnote)
                    labeledContent(".caption", font: .caption)
                    labeledContent(".caption2", font: .caption2)
                }
            } header: {
                Text("内置字体")
            } footer: {
                Text("试试调整系统文字大小：\(text)")
            }
            
            Section("字体样式") {
                LabeledContent {
                    Text(.now, style: .timer)
                        .font(.system(size: fontSize))
                } label: {
                    Text("指定 size")
                }
                .padding(.vertical)
                .if(monospaced) { view in
                    view.monospaced()
                }
                
                LabeledContent(
                    "fontSize: \(String(format: "%.1f", fontSize))"
                ) {
                    Slider(value: $fontSize, in: 10...30)
                }
                
                Toggle(".monospaced()", isOn: $monospaced)
            }
        }
        .formStyle(.grouped)
    }
    
    var text: String {
#if os(iOS)
        "设置 > 显式与亮度 > 文字大小"
#else
        "设置 > 显示器 > 缩放分辨率"
#endif
    }
    
    @ViewBuilder func labeledContent(
        _ title: String,
        font: Font
    ) -> some View {
        LabeledContent {
            Text("Hello World")
                .font(font)
                .foregroundColor(.primary)
        } label: {
            Text(title)
                .foregroundColor(.secondary)
        }
    }
    
}

fileprivate enum MonospaceType {
    case monospaced
    case monospacedDigit
}

struct SampleFonts_Previews: PreviewProvider {
    static var previews: some View {
        SampleFonts()
    }
}

