//
//  SampleProgressView.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleProgressView: View {
    @State private var hasLabel = true
    @State private var progressViewType = ProgressViewType.automatic
    @State private var countsDown = true
    @State private var value: Double = 0.0
    @State private var value2: Double = 0.6
    
    var body: some View {
        Form {
            Section("基本使用") {
                progressView
                
                Toggle("label", isOn: $hasLabel)
                Picker(
                    ".progressViewStyle",
                    selection: $progressViewType
                ) {
                    ForEach(ProgressViewType.allCases, id: \.self) {
                        Text($0.description)
                    }
                }
            }
            
            Section {
                ProgressView(value: value) {
                    Text("Progress")
                        .foregroundColor(.purple)
                }
                .tint(.purple)
                LabeledContent("更新进度") {
                    Slider(value: $value)
                }
            } footer: {
                Text("total 默认为 1.0")
            }
            
            Section {
                ProgressView(value: 3, total: 5) {
                    Text("Download")
                } currentValueLabel: {
                    Text("2/5")
                }
            } footer: {
                Text("指定 value 和 total，添加 currentValueLabel")
            }
            
            Section {
                ProgressView(
                    timerInterval: Date.now...Date.now.addingTimeInterval(10),
                    countsDown: countsDown
                )
                Toggle("countsDown", isOn: $countsDown)
            }
            
            Section("自定义 ProgressViewStyle") {
                HStack(spacing: 20) {
                    ProgressView(value: value2)
                        .progressViewStyle(.gradientCircle)
                    
                    ProgressView(value: value2)
                        .progressViewStyle(.shadow)
                }
                .padding(.vertical)
                
                Slider(value: $value2) {
                    Text("Percent")
                }
            }
            .textCase(nil)
        }
        .formStyle(.grouped)
    }
    
    @ViewBuilder private var progressView: some View {
        let pgv = ProgressView() {
            if hasLabel {
                Text("Loading...")
            }
        }
        switch progressViewType {
        case .automatic:
            pgv.progressViewStyle(.automatic)
        case .circular:
            pgv.progressViewStyle(.circular)
        case .linear:
            pgv.progressViewStyle(.linear)
        }
    }
}

fileprivate enum ProgressViewType:
    String, CaseIterable, CustomStringConvertible {
    case automatic
    case circular
    case linear
    
    var description: String {
        ".\(rawValue)"
    }
}

fileprivate struct GradientCircleProgressViewStyle:
    ProgressViewStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0.0
        ZStack {
            Circle()
                .stroke(.secondary.opacity(0.3), lineWidth: 8)
            
            Circle()
            // trim 将形状的绘制路径等比例分割，范围是 0.0...1.0
            // from 表示开始的位置，to 表示结束位置
                .trim(from: 0.0, to: fractionCompleted)
                .stroke(
                    .linearGradient(
                        colors: [.red, .orange, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: .init(lineWidth: 8, lineCap: .round, lineJoin: .round)
                )
                .animation(.default, value: fractionCompleted)
            
            Text(
                Double(String(format: "%.2f", fractionCompleted))!
                    .formatted(.percent)
            )
            .monospaced()
        }
        .frame(width: 66, height: 66)
    }
}

fileprivate extension ProgressViewStyle
where Self == GradientCircleProgressViewStyle{
    static var gradientCircle: Self { .init() }
}

fileprivate struct ShadowProgressViewStyle:
    ProgressViewStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        // 基于现有的 style 更方便的自定义样式
        ProgressView(configuration)
            .padding(5)
            .tint(.orange)
            .background(
                Capsule()
                    .foregroundColor(.primary)
                    .shadow(color: .primary, radius: 4)
            )
    }
}

fileprivate extension ProgressViewStyle
where Self == ShadowProgressViewStyle{
    static var shadow: Self { .init() }
}

struct SampleProgressView_Previews: PreviewProvider {
    static var previews: some View {
        SampleProgressView()
            .preferredColorScheme(.dark)
    }
}

