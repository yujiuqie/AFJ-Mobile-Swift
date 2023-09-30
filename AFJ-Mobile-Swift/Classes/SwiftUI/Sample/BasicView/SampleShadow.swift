//
//  SampleShadow.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleShadow: View {
    @StateObject private var vm: SampleShadowViewModel = .init()
    @State private var shadowView: ShadowViewType = .text
    @State private var isInnerShadow = true
    
    var body: some View {
        Form {
            Group {
                shadow
                innerShadow
            }
            .textCase(nil)
        }
        .formStyle(.grouped)
    }
    
    private var shadow: some View {
        Section("Shadow") {
            Text("Hello World")
                .font(.title3)
                .padding(30)
                .shadow(
                    color: vm.textShadow.color
                        .opacity(vm.textShadow.opacity),
                    radius: vm.textShadow.radius,
                    x: vm.textShadow.x,
                    y: vm.textShadow.y)
                .background(
                    background
                        .cornerRadius(10)
                        .shadow(
                            color: vm.bgShadow.color
                                .opacity(vm.bgShadow.opacity),
                            radius: vm.bgShadow.radius,
                            x: vm.bgShadow.x,
                            y: vm.bgShadow.y)
                )
                .padding(30)
                .frame(maxWidth: .infinity)
                .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
            
            VStack {
                Picker("shadow view", selection: $shadowView) {
                    ForEach(ShadowViewType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                
                ShadowConfigView(
                    shadow: shadowView == .text
                    ? $vm.textShadow
                    : $vm.bgShadow
                )
            }
        }
    }
    
    private var innerShadow: some View {
        Section("Innder Shadow") {
            Image(systemName: "applelogo")
                .font(.title)
                .padding(25)
                .background(circle)
                .frame(maxWidth: .infinity)
            
            Toggle(".inner", isOn: $isInnerShadow.animation())
        }
    }
    
    @ViewBuilder var circle: some View {
        Group {
            if isInnerShadow {
                Circle()
                    .fill(.shadow(.inner(radius: 5)))
            } else {
                Circle()
                    .fill(.shadow(.drop(radius: 5)))
            }
        }
        .foregroundColor(background)
    }
    
    var background: Color {
#if os(iOS)
        Color(.systemBackground)
#else
        Color(.windowBackgroundColor)
#endif
    }
}

fileprivate struct ShadowConfigView: View {
    @Binding var shadow: Shadow
    
    var body: some View {
        Group {
            ColorPicker("color", selection: $shadow.color)
            Divider()
            
            LabeledContent {
                Slider(value: $shadow.opacity, in: 0.0...1.0)
            } label: {
                Text("opacity: \(shadow.opacity, specifier: "%.1f")")
            }
            Divider()
            
            LabeledContent {
                Slider(value: $shadow.radius, in: 0...20)
            } label: {
                Text("radius: \(shadow.radius, specifier: "%.0f")")
            }
            Divider()
            
            LabeledContent {
                Slider(value: $shadow.x, in: -15.0...15.0)
            } label: {
                Text("x: \(shadow.x, specifier: "%.1f")")
            }
            Divider()
            
            LabeledContent {
                Slider(value: $shadow.y, in: -15.0...15.0)
            } label: {
                Text("y: \(shadow.y, specifier: "%.1f")")
            }
            Divider()
        }
    }
}

fileprivate enum ShadowViewType: String, CaseIterable {
    case text = "text"
    case background = "background"
}

final fileprivate class SampleShadowViewModel: ObservableObject {
    @Published var textShadow: Shadow = .init()
    @Published var bgShadow: Shadow = .init()
    @Published var shadowView: ShadowViewType = .text
}

fileprivate struct Shadow {
    var color: Color = .accentColor
    var opacity: Double = 1.0
    var radius: CGFloat = 3
    var x: CGFloat = 5
    var y: CGFloat = 5
}

struct SampleShadow_Previews: PreviewProvider {
    static var previews: some View {
        SampleShadow()
    }
}

