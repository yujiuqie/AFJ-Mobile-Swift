//
//  SampleText.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/17.
//

import SwiftUI

struct SampleText: View {
    private let s1 = "Stay Hungry, Stay Foolish!"
    @State private var lineLimit = 1
    @State private var truncationMode: Text.TruncationMode = .tail
    @State private var multilineTextAlignment: TextAlignment = .leading
    @State private var reservesSpace = true
    
    var body: some View {
        Form {
            Section("字符串") {
                Text(Array(repeating: s1, count: 5).joined())
                // .lineLimit(3)
                    .lineLimit(lineLimit, reservesSpace: reservesSpace) // 显示空行占位空间
                    .multilineTextAlignment(multilineTextAlignment) // 多行文字对齐方式
                    .truncationMode(truncationMode) // 文字截断魔术
                    .textSelection(.enabled) // iOS 15 新增，长按可复制
                Toggle("reservesSpace", isOn: $reservesSpace)
                Stepper("lineLimit: \(lineLimit)", value: $lineLimit, in: 1...6)
                Picker("truncationMode", selection: $truncationMode) {
                    ForEach(Text.TruncationMode.allCases, id: \.self) { v in
                        Text(v.text)
                    }
                }
                Picker("multilineTextAlignment", selection: $multilineTextAlignment) {
                    ForEach(TextAlignment.allCases, id: \.self) { v in
                        Text(v.text)
                    }
                }
            }
            
            Section("格式化") {
                LabeledContent(".number") {
                    Text(0.1230, format: .number)
                    // 等同于
                    // Text(0.1230.formatted())
                }
                LabeledContent(".percent") {
                    Text(0.1230, format: .percent)
                    // 等同于
                    // Text(0.1230.formatted(.percent))
                }
                LabeledContent(".currency") {
                    Text(12345.678, format: .currency(code: "USD"))
                }
                LabeledContent(".dateTime") {
                    Text(Date.now, format: .dateTime)
                    // 等同于
                    // Text(Date.now.formatted())
                }
                LabeledContent(".formatted") {
                    Text(Date.now.formatted(date: .numeric, time: .omitted))
                }
                LabeledContent("month&day") {
                    Text(Date.now, format: Date.FormatStyle().month(.twoDigits).day())
                }
                LabeledContent("dayOfYear") {
                    Text(Date.now, format: Date.FormatStyle().dayOfYear())
                }
                LabeledContent("week") {
                    Text(Date.now, format: Date.FormatStyle().week())
                }
                LabeledContent(".list") {
                    Text(["A", "B", "C"], format: .list(type: .and))
                }
                LabeledContent(".list") {
                    Text([1, 2, 3], format: .list(memberStyle: .number, type: .or))
                }
            }
            
            Section("富文本") {
                Text("\(Image(systemName: "applelogo")) Apple    ")
                    .foregroundColor(.blue).bold() +
                Text("\(Image(systemName: "swift")) Swift")
                    .foregroundColor(.orange).italic()
            }
            
            Section("Markdown") {
                Text("**This** ~~is~~ an *example* of  ***Markdown*** `Text`, [See More](https://developer.apple.com/documentation/swiftui/text)")
            }
            .textCase(nil)
            
            Section("渐变文字") {
                Text(s1)
                    .font(.title3).bold()
                    .foregroundStyle(.linearGradient(
                        colors: [.orange, .yellow, .blue, .purple],
                        startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                
                HStack {
                    // 只设置一种 style，会自动依次减弱
                    foregroundStyleView
                    // .foregroundColor(.blue) // 效果等同于下面代码
                        .foregroundStyle(.blue)
                    
                    // 设置了多种 style，会根据顺序渲染
                    // 如果超出设置的 style 数量（最多三种）
                    // 会使用最后一种 style
                    foregroundStyleView
                        .foregroundStyle(.blue, .red, .purple)
                    foregroundStyleView
                        .foregroundStyle(.blue, .red)
                }
            }
            
            Section("日期") {
                // 日期
                LabeledContent(".date") {
                    Text(.now, style: .date)
                }
                
                // 时间
                LabeledContent(".time") {
                    Text(.now, style: .time)
                }
                
                // 与现在的时间差
                LabeledContent(".offset") {
                    Text(.now, style: .offset)
                }
                
                // 相对现在的时间
                LabeledContent(".relative") {
                    Text(.now, style: .relative)
                }
                
                // 计时器
                LabeledContent(".timer") {
                    Text(.now, style: .timer)
                }
                
                // 通过时间范围构造
                LabeledContent("ClosedRange") {
                    Text(.now...(.now.addingTimeInterval(3600)))
                }
                
                // 通过 DateInterval 构造
                LabeledContent("DateInterval") {
                    Text(DateInterval(start: .now, duration: 3600))
                }
            }
        }
        .formStyle(.grouped)
    }
    
    var foregroundStyleView: some View {
        VStack {
            Label("Apple", systemImage: "applelogo")
            // .foregroundStyle(.primary) // 默认
            Label("Apple", systemImage: "applelogo")
                .foregroundStyle(.secondary)
            Label("Apple", systemImage: "applelogo")
                .foregroundStyle(.tertiary)
            Label("Apple", systemImage: "applelogo")
                .foregroundStyle(.quaternary)
        }
    }
}

extension Text.TruncationMode: CaseIterable {
    public static var allCases: [Text.TruncationMode] = [
        .head, .middle, .tail
    ]
    
    var text: String {
        switch self {
        case .head:
            return ".head"
        case .middle:
            return ".middle"
        case .tail:
            return ".tail"
        @unknown default:
            return "unknown"
        }
    }
}

extension TextAlignment {
    
    var text: String {
        switch self {
        case .leading:
            return ".leading"
        case .center:
            return ".center"
        case .trailing:
            return ".trailing"
        }
    }
}

struct SampleText_Previews: PreviewProvider {
    static var previews: some View {
        SampleText()
    }
}

