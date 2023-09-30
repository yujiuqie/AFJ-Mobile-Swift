//
//  SampleButton.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleButton: View {
    @State private var buttonRoleType: ButtonRoleType = .none
    @State private var isTint = false
    @State private var tintColor: Color = .accentColor
    @State private var doubleTapCount = 0
    
    var body: some View {
        Form {
            Group {
                Section("基础构建") {
                    ButtonInitialize()
                        .buttonStyle(.borderless)
                }
                
                Section("ButtonStyle") {
                    ButtonStyleView(
                        buttonRoleType: $buttonRoleType,
                        isTint: $isTint,
                        tintColor: $tintColor
                    )
                }
                
                Section {
                    Picker("role", selection: $buttonRoleType) {
                        ForEach(ButtonRoleType.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    VStack {
                        Toggle("tint", isOn: $isTint)
                        if isTint {
                            ColorPicker("color", selection: $tintColor)
                        }
                    }
                }
                
                Section("自定义样式") {
                    LabeledContent("ShadowButtonStyle") {
                        Button("Hello World") {}
                            .buttonStyle(ShadowButtonStyle(radius: 5))
                    }
                    .padding(.vertical)
                    
                    LabeledContent {
                        Button("Double Tap") {
                            doubleTapCount += 1
                        }
                        .buttonStyle(.doubleTap)
                    } label: {
                        Text("DoubleTapButtonStyle\n") +
                        Text("Count: \(doubleTapCount)")
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical)
                }
            }
            .textCase(nil)
        }
        .formStyle(.grouped)
    }
}

fileprivate struct ShadowButtonStyle: ButtonStyle {
    let radius: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        // configuration.label 是按钮实体
        configuration.label
            .padding()
        // configuration.isPressed 表示按钮是否按下
            .foregroundColor(configuration.isPressed ? .gray : .white)
            .background(
                Capsule()
                    .fill(.shadow(
                        configuration.isPressed
                        ? .inner(radius: radius)
                        : .drop(radius: radius)
                    ))
                    .foregroundStyle(
                        .linearGradient(
                            colors: configuration.isPressed
                            ? [.blue, .purple]
                            : [.orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing)
                    )
            )
            .animation(.default, value: configuration.isPressed)
    }
}

fileprivate extension ButtonStyle
where Self == ShadowButtonStyle {
    static func shadow(radius: CGFloat) -> Self {
        .init(radius: radius)
    }
}

fileprivate struct DoubleTapButtonStyle: PrimitiveButtonStyle {
    @State private var scale: Double = 1.0
    @State private var isTrigger = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
            .scaleEffect(isTrigger ? 1.0 : 1.1)
            .gesture(
                TapGesture(count: 2)
                    .onEnded {
                        configuration.trigger()
                        isTrigger = false
                        withAnimation(.spring(dampingFraction: 0.5)) {
                            isTrigger = true
                        }
                    }
            )
    }
}

fileprivate extension PrimitiveButtonStyle
where Self == DoubleTapButtonStyle {
    static var doubleTap: Self { Self() }
}

fileprivate struct ButtonStyleView: View {
    @Binding var buttonRoleType: ButtonRoleType
    @Binding var isTint: Bool
    @Binding var tintColor: Color
    
    var body: some View {
        button(.automatic, text: ".automatic")
        button(.bordered, text: ".bordered")
        button(.borderedProminent, text: ".borderedProminent")
        button(.borderless, text: ".borderless")
        button(.plain, text: ".plain")
#if os(macOS)
        button(.link, text: ".link")
#endif
    }
    
    @ViewBuilder private func button(
        _ style: some PrimitiveButtonStyle,
        text: String
    ) -> some View {
        LabeledContent {
            Button("Click", role: buttonRoleType.value) {}
                .if(isTint) { view in
                    view.tint(tintColor)
                }
                .buttonStyle(style)
        } label: {
            Text(text)
        }
    }
}

fileprivate enum ButtonRoleType: String, CaseIterable {
    case none = "nil"
    case cancel = ".cancel"
    case destructive = ".destructive"
    
    var value: ButtonRole? {
        switch self {
        case .none:
            return nil
        case .cancel:
            return .cancel
        case .destructive:
            return .destructive
        }
    }
}

fileprivate struct ButtonInitialize: View {
    @State private var clickCount = 0
    
    var body: some View {
        LabeledContent {
            Button("Click") {
                clickCount += 1
            }
            .frame(minWidth: 120, minHeight: 50)
            .foregroundColor(.white)
            .background(.blue)
            .clipShape(Capsule())
        } label: {
            Text("字符串构建")
        }
        
        LabeledContent {
            Button {
                clickCount += 1
            } label: {
                Text("Click")
                    .frame(minWidth: 120, minHeight: 50)
                    .foregroundColor(.white)
                    .background(.blue)
                    .clipShape(Capsule())
            }
        } label: {
            Text("view 构建")
        }
        
        Text("count")
            .badge(clickCount)
    }
}

struct SampleButton_Previews: PreviewProvider {
    static var previews: some View {
        SampleButton()
        //      .preferredColorScheme(.dark)
    }
}

