//
//  SampleLayoutSharing.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/27.
//

import SwiftUI

struct SampleLayoutSharing: View {
    @State private var globalFrame = CGRect.zero
    @State private var localFrame = CGRect.zero
    @State private var namedFrame = CGRect.zero
    
    var body: some View {
        Form {
            Section {
                GeometryReaderView(
                    globalFrame: $globalFrame,
                    localFrame: $localFrame,
                    namedFrame: $namedFrame
                )
            } header: {
                Text("GeometryReader")
            } footer: {
                VStack(alignment: .leading) {
                    Text("globalFrame: \(globalFrame.debugDescription)")
                    Text("localFrame: \(localFrame.debugDescription)")
                    Text("namedFrame: \(namedFrame.debugDescription)")
                }
            }
            .textCase(nil)
            
            Section("PreferenceKey") {
                PreferenceKeyView()
            }
        }
        .formStyle(.grouped)
    }
}

fileprivate struct GeometryReaderView: View {
    @Binding var globalFrame: CGRect
    @Binding var localFrame: CGRect
    @Binding var namedFrame: CGRect
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                VStack {
                    Rectangle()
                        .fill(.blue)
                        .frame(height: proxy.size.height / 3)
                    
                    Rectangle()
                        .fill(.blue)
                        .frame(height: proxy.size.height * 2 / 3)
                }
                .onAppear {
                    globalFrame = proxy.frame(in: .global)
                    localFrame = proxy.frame(in: .local)
                    namedFrame = proxy.frame(in: .named("VStack"))
                }
            }
            .frame(height: 300)
        }
        .frame(height: 400)
        .background(.orange)
        .coordinateSpace(name: "VStack")
    }
}

fileprivate struct PreferenceKeyView: View {
    @State private var rectangleWidth: CGFloat = 100
    @State private var rectangleHeight: CGFloat = 100
    @State private var size: CGSize = .zero
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(.blue)
                .frame(width: rectangleWidth, height: rectangleHeight)
                .onChangeOfSize { size in
                    self.size = size
                }
            
            Text("size: \(size.debugDescription)")
                .foregroundColor(.secondary)
            
            LabeledContent("width: \(rectangleWidth, specifier: "%.0f")") {
                Slider(value: $rectangleWidth, in: 50...150)
            }
            LabeledContent("height: \(rectangleHeight, specifier: "%.0f")") {
                Slider(value: $rectangleHeight, in: 50...150)
            }
        }
        .frame(height: 300)
    }
}

fileprivate struct SizeModifer: ViewModifier {
    let onChange: (CGSize) -> Void
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                    // 获取尺寸信息并传递给 BoundsPreferenceKey
                        .anchorPreference(
                            key: BoundsPreferenceKey.self,
                            value: .bounds
                        ) {
                            proxy[$0]
                        }
                    // 监听 BoundsPreferenceKey 值的变化并回传
                        .onPreferenceChange(BoundsPreferenceKey.self) {
                            onChange($0.size)
                        }
                }
            )
    }
}

fileprivate struct BoundsPreferenceKey: PreferenceKey {
    
    // 没有设置 PreferenceKey 时的默认值
    static var defaultValue: CGRect = .zero
    
    // 收集视图树中的数据
    // nextValue 是惰性调用的，需要时才会去获取相应的值
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

fileprivate extension View {
    
    func onChangeOfSize(
        perform action: @escaping (CGSize) -> Void
    ) -> some View {
        modifier(SizeModifer(onChange: action))
    }
}

struct SampleLayoutSharing_Previews: PreviewProvider {
    static var previews: some View {
        SampleLayoutSharing()
    }
}

