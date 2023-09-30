//
//  SampleTextField.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/17.
//

import SwiftUI

struct SampleTextField: View {
    @State private var text1 = ""
    @State private var styleSelection = TextFieldType.roundedBorder
    
    @State private var text2 = ""
    @State private var axisSelection: Axis = .vertical
    
    @State private var text3: Double = 0.0
    
    @State private var text4 = ""
    @State private var statusText = ""
    @State private var dismissMode: DismissMode = .immediately
    @State private var isSubmitted = ""
    @FocusState private var isFocused: Bool
#if os(iOS)
    @State private var keyboardType: UIKeyboardType = .default
#endif
    
    @State private var pwd = ""
    
    private var isOn: Binding<Bool> {
        Binding {
            isFocused
        } set: { value in
            isFocused = value
        }
    }
    
    var body: some View {
        Form {
            Section("设置 TextFieldStyle") {
                textfield1
                Picker(".textFieldStyle", selection: $styleSelection) {
                    ForEach(TextFieldType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
            }
            .textCase(nil)
            
            Section("设置扩充方向") {
                TextField("text2", text: $text2, axis: axisSelection)
                    .lineLimit(3) // 最多三行
                    .textFieldStyle(.roundedBorder)
                Picker("axis", selection: $axisSelection) {
                    ForEach(Axis.allCases, id: \.self) {
                        Text($0.description)
                    }
                }
            }
            
            
            Section("格式转换") {
                TextField("text3", value: $text3, format: .number)
                    .textFieldStyle(.roundedBorder)
            }
            
            Section("状态、键盘") {
#if os(iOS)
                Picker(".scrollDismissesKeyboard", selection: $dismissMode) {
                    ForEach(DismissMode.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
#endif
                
                Toggle("键盘", isOn: isOn)
                
                Text("状态：") +
                Text(statusText).bold().italic()
                    .foregroundColor(.blue)
                
#if os(iOS)
                Picker(".keyboardType", selection: $keyboardType) {
                    ForEach(UIKeyboardType.allCases, id: \.self) {
                        Text($0.text)
                    }
                }
#endif
                
                TextField("text4", text: $text4)
#if os(iOS)
                    .keyboardType(keyboardType)
#endif
                    .textFieldStyle(.roundedBorder)
                    .focused($isFocused)
                    .onSubmit {
                        printLog("return")
                        isSubmitted = "return & "
                    }
                    .onChange(of: isFocused) { newValue in
                        printLog(newValue)
                        if newValue { isSubmitted = "" }
                        statusText = newValue ? "active" : "\(isSubmitted)inactive"
                    }
            }
            
            Section("SecureField") {
                SecureField("password", text: $pwd, prompt: Text("Required"))
            }
            .textCase(nil)
        }
        .formStyle(.grouped)
#if os(iOS)
        .scrollDismissesKeyboard(dismissMode.value)
        .onChange(of: keyboardType) { newValue in
            printLog(newValue)
            // 键盘视图特殊，keyboardType 变更时，键盘无法刷新
            // workaround：收起键盘，再激活
            isFocused = false
            isFocused = true
        }
#endif
    }
    
    @ViewBuilder var textfield1: some View {
        let tf = TextField("text1", text: $text1)
        switch styleSelection {
        case .automatic:
            tf.textFieldStyle(.automatic)
        case .plain:
            tf.textFieldStyle(.plain)
        case .roundedBorder:
            tf.textFieldStyle(.roundedBorder)
#if os(macOS)
        case .squareBorder:
            tf.textFieldStyle(.squareBorder)
#endif
        }
    }
}

#if os(iOS)
extension UIKeyboardType: CaseIterable {
    public static var allCases: [UIKeyboardType] {
        [
            .default,
            .asciiCapable,
            .numbersAndPunctuation,
            .URL,
            .numberPad,
            .phonePad,
            .namePhonePad,
            .emailAddress,
            .decimalPad,
            .twitter,
            .webSearch,
            .asciiCapableNumberPad
        ]
    }
    
    var text: String {
        switch self {
        case .default:
            return ".default"
        case .asciiCapable:
            return ".asciiCapable"
        case .numbersAndPunctuation:
            return ".numbersAndPunctuation"
        case .URL:
            return ".URL"
        case .numberPad:
            return ".numberPad"
        case .phonePad:
            return ".phonePad"
        case .namePhonePad:
            return ".namePhonePad"
        case .emailAddress:
            return ".emailAddress"
        case .decimalPad:
            return ".decimalPad"
        case .twitter:
            return ".twitter"
        case .webSearch:
            return ".webSearch"
        case .asciiCapableNumberPad:
            return ".asciiCapableNumberPad"
        @unknown default:
            return "unknown"
        }
    }
}
#endif

fileprivate enum DismissMode: String, CaseIterable {
    case automatic = ".automatic"
    case immediately = ".immediately"
    case interactively = ".interactively"
    case never = ".never"
    
    var value: ScrollDismissesKeyboardMode {
        switch self {
        case .automatic:
            return .automatic
        case .immediately:
            return .immediately
        case .interactively:
            return .interactively
        case .never:
            return .never
        }
    }
}

fileprivate enum TextFieldType: String, CaseIterable {
    case automatic = "automatic"
    case plain = "plain"
    case roundedBorder = "roundedBorder"
#if os(macOS)
    case squareBorder = "squareBorder"
#endif
}

struct SampleTextField_Previews: PreviewProvider {
    static var previews: some View {
        SampleTextField()
    }
}

