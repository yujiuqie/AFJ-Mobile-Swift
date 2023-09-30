//
//  SampleLabel.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/17.
//

import SwiftUI

struct SampleLabel: View {
    
    var body: some View {
        Form {
            Section("从文本和图片构建") {
                LabeledContent("SF Symbols") {
                    Label("Swift", systemImage: "swift")
                }
                LabeledContent("资源图片") {
                    Label("Eul", image: "icon_small")
                        .padding(.vertical)
                }
            }
            .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
            
            Section("自定义 title 和 icon") {
                Label {
                    Text("iPhone Plus")
                        .foregroundStyle(.linearGradient(
                            .init(colors: [.blue, .purple]),
                            startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .bold()
                } icon: {
                    Image(systemName: "iphone")
                        .font(.title)
                        .foregroundStyle(.purple)
                }
            }
            .textCase(nil)
            
            Section("设置 LabelStyle") {
                LabeledContent(".automatic") {
                    Label("Apple", systemImage: "applelogo")
                        .labelStyle(.automatic)
                }
                LabeledContent(".titleAndIcon") {
                    Label("Apple", systemImage: "applelogo")
                        .labelStyle(.titleAndIcon)
                }
                LabeledContent(".titleOnly") {
                    Label("Apple", systemImage: "applelogo")
                        .labelStyle(.titleOnly)
                }
                LabeledContent(".iconOnly") {
                    Label("Apple", systemImage: "applelogo")
                        .labelStyle(.iconOnly)
                }
            }
            .textCase(nil)
            .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
            
            Section("自定义 LabelStyle") {
                Label("Apple", systemImage: "applelogo")
                    .labelStyle(.myStyle(spacing: 10))
            }
            .textCase(nil)
        }
        .formStyle(.grouped)
    }
}

fileprivate struct MyStyle: LabelStyle {
    let spacing: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: spacing) {
            configuration.icon
            configuration.title
        }
        .font(.title3)
        .bold()
        .shadow(color: .blue, radius: 2)
        .foregroundStyle(.linearGradient(
            .init(colors: [.red, .orange, .blue, .purple]),
            startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

fileprivate extension LabelStyle where Self == MyStyle {
    
    static func myStyle(spacing: CGFloat) -> Self {
        .init(spacing: spacing)
    }
}

struct SampleLabel_Previews: PreviewProvider {
    static var previews: some View {
        SampleLabel()
    }
}

