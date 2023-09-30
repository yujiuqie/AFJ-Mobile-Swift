//
//  SamplePropertyWrappers.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/17.
//

import SwiftUI

struct SamplePropertyWrappers: View {
    @StateObject private var envWeathersObject = WeathersVM()
    
    var body: some View {
        Form {
            section(title: "Model Data", view: SampleModelData())
            section(title: "Environment Values", view: SampleEnvironmentValues())
            section(title: "Persistent Storage", view: SamplePersistentStorage())
            section(title: "Interaction", view: SampleInteraction())
            section(title: "Custom Property Wrappers", view: SampleCustomPropertyWrappers())
        }
        .formStyle(.grouped)
        .environmentObject(envWeathersObject)
        .scrollDismissesKeyboard(.interactively)
    }
    
    private func section(title: String, view: some View) -> some View {
        Section(title) { view }.textCase(nil)
    }
}

// MARK: - Model Data

fileprivate struct SampleModelData: View {
    @State private var showTemperature = true
    @StateObject private var soVm = WeathersVM()
    @ObservedObject private var ooVm = WeathersVM()
    @State private var toObservedObject = false
    
    var body: some View {
        VStack {
            ForEach((toObservedObject ? ooVm : soVm).weathers, id: \.id) { v in
                LabeledContent {
                    Text(v.temperature.celsiusFormat)
                        .opacity(showTemperature ? 1 : 0)
                } label: {
                    Label(v.name, systemImage: v.icon)
                }
            }
            Divider()
            
            Toggle("显示温度", isOn: $showTemperature.animation())
                .toggleStyle(.switch)
            Divider()
            
            BindingView(weathers: $soVm.weathers)
            Divider()
            
            CustomBindingView()
            Divider()
            
            Toggle("使用 ObservedObject", isOn: $toObservedObject.animation())
                .toggleStyle(.switch)
        }
    }
}

fileprivate final class WeathersVM: ObservableObject {
    @Published var weathers: [Weather] = []
    
    /**
     手动调用 `objectWillChange.send()`
     同样可以实现 @Published 的效果
     但是可以在属性值变化时，做一些额外的附加操作
     */
    /**
     var weathers: [Weather] = [] {
     willSet {
     objectWillChange.send()
     }
     didSet {
     // 值更新之后的附加操作
     }
     }
     */
    
    func shuffleWeathers() {
        weathers.shuffle()
    }
    
    init() {
        weathers = Weather.mock
    }
}

fileprivate struct BindingView: View {
    @Binding var weathers: [Weather]
    
    var body: some View {
        LabeledContent(
            weathers.map { $0.name }.joined(separator: " - ")
        ) {
            Button("天气顺序随机") {
                weathers.shuffle()
            }
            .buttonStyle(.bordered)
        }
    }
}

fileprivate struct CustomBindingView: View {
    @State private var isPwdRemembered = false
    @State private var isAutoLogin = false
    @State private var username = ""
    @State private var pwd = ""
    
    private var pwdBinding: Binding<Bool> {
        Binding {
            self.isPwdRemembered
        } set: { value in
            if !value { isAutoLogin = false }
            self.isPwdRemembered = value
        }
    }
    
    private var loginBinding: Binding<Bool> {
        Binding {
            self.isAutoLogin
        } set: { value in
            if value && !self.isPwdRemembered {
                self.isPwdRemembered = true
            }
            self.isAutoLogin = value
            
            if self.isAutoLogin {
                username = "username"
                pwd = "11111111"
            } else {
                username = ""
                pwd = ""
            }
        }
    }
    
    var body: some View {
        VStack {
            Group {
                TextField("用户名", text: $username)
                SecureField("密码", text: $pwd)
            }
            .textFieldStyle(.roundedBorder)
            
            HStack {
                Toggle("记住密码", isOn: pwdBinding)
                Toggle("自动登录", isOn: loginBinding)
            }
            .fixedSize()
#if os(macOS)
            .toggleStyle(.checkbox)
#endif
        }
    }
}

// MARK: - Environment Values

fileprivate struct SampleEnvironmentValues: View {
    @EnvironmentObject private var weatherVm: WeathersVM
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack {
            LabeledContent("ColorScheme") {
                Text(colorScheme == .light ? "Light" : "Dark")
            }
            Divider()
            
            AView()
                .environment(\.userId, "username")
            Divider()
            VStack {
                Text("通过 @EnvironmentObject 注入：")
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    ForEach(weatherVm.weathers.indices, id: \.self) { i in
                        Label(
                            weatherVm.weathers[i].name,
                            systemImage: weatherVm.weathers[i].icon
                        )
                        Divider()
                            .opacity(i == weatherVm.weathers.count - 1 ? 0 : 1)
                    }
                }
            }
        }
    }
}

fileprivate struct AView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.purple, .orange],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            BView()
        }
        .frame(width: 300, height: 150)
        .cornerRadius(15)
    }
}

fileprivate struct BView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.cyan, .indigo],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            CView()
        }
        .frame(width: 250, height: 100)
        .cornerRadius(10)
    }
}

fileprivate struct CView: View {
    @Environment(\.userId) private var userId
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue, .black.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Text(userId)
                .foregroundStyle(
                    .linearGradient(
                        colors: [.gray, .white, .gray, .white],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
        .frame(width: 200, height: 50)
        .cornerRadius(5)
    }
}

private struct UserIdKey: EnvironmentKey {
    static var defaultValue: String = ""
}

extension EnvironmentValues {
    var userId: String {
        get { self[UserIdKey.self] }
        set { self[UserIdKey.self] = newValue }
    }
}

// MARK: - Persistent Storage

fileprivate struct SamplePersistentStorage: View {
    @AppStorage("sample_app_text") private var appText = "appText"
    @SceneStorage("sample_scene_text") private var sceneText = "sceneText"
    
    var body: some View {
        VStack {
            TextField("AppStorage", text: $appText)
            Divider()
            TextField("SceneStorage",  text: $sceneText)
        }
        .textFieldStyle(.roundedBorder)
    }
}

// MARK: - Interaction

fileprivate struct SampleInteraction: View {
    
    var body: some View {
        VStack {
            SampleGestureState()
            Divider()
            
            SampleNameSpace()
            Divider()
            
            SampleScaledMetric()
            Divider()
            
            SampleFocusState()
            Divider()
            
            SampleFocusedValue()
            Divider()
        }
    }
}

fileprivate struct SampleGestureState: View {
    @GestureState private var dragOffset = CGSize.zero
    @State private var position = CGSize.zero
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: .init(colors: [.red, .orange, .yellow]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .offset(
                x: position.width + dragOffset.width,
                y: position.height + dragOffset.height
            )
            .gesture(
                DragGesture()
                    .updating($dragOffset) { (currentState, gestureState, transaction) in
                        // 更新
                        gestureState = currentState.translation
                    }
                    .onEnded { value in
                        // 保存当前位置
                        self.position.width += value.translation.width
                        self.position.height += value.translation.height
                    }
            )
        }
        .frame(height: 200)
    }
}

fileprivate struct SampleNameSpace: View {
    @Namespace private var profileTransition
    @State private var isVertical = false
    @State private var duration = 0.3
    
    var body: some View {
        VStack(spacing: 40) {
            if isVertical {
                VStack {
                    RoundedRectangle(cornerRadius: 20)
                        .matchedGeometryEffect(id: "avatar", in: profileTransition)
                        .foregroundColor(.purple)
                        .frame(width: 200, height: 200)
                    HStack {
                        Text("@username")
                            .matchedGeometryEffect(id: "name", in: profileTransition)
                            .bold()
                            .foregroundColor(.purple)
                        
                        Text("Author of Eul")
                            .matchedGeometryEffect(id: "intro", in: profileTransition)
                            .foregroundColor(.secondary)
                    }
                }
            } else {
                HStack {
                    RoundedRectangle(cornerRadius: 22)
                        .matchedGeometryEffect(id: "avatar", in: profileTransition)
                        .foregroundColor(.blue)
                        .frame(width: 44, height: 44)
                    VStack(alignment: .leading) {
                        
                        Text("@username")
                            .matchedGeometryEffect(id: "name", in: profileTransition)
                            .bold()
                            .foregroundColor(.blue)
                        
                        Text("Author of Eul")
                            .matchedGeometryEffect(id: "intro", in: profileTransition)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
            }
            
            HStack {
                Text("动画时长: \(duration.formatted()) s")
                Slider(value: $duration, in: (0.3...3.0), step: 0.3)
            }
        }
        .padding(.vertical)
        .onTapGesture {
            withAnimation(.linear(duration: duration)) {
                isVertical.toggle()
            }
        }
    }
}

fileprivate struct SampleScaledMetric: View {
    @ScaledMetric private var scaledFontSize = 60
    @ScaledMetric private var scaledImageSize = 100
    
    var body: some View {
        VStack {
            Image(systemName: "apple.logo")
                .font(.system(size: scaledFontSize))
                .foregroundStyle(
                    .linearGradient(
                        .init(colors: [.white, .black]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Image("parrot")
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
                .frame(width: scaledImageSize, height: scaledImageSize)
            
            Text("试试调整系统文字大小：\(text)")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
    
    var text: String {
#if os(iOS)
        "设置 > 显式与亮度 > 文字大小"
#else
        "设置 > 显示器 > 缩放分辨率"
#endif
    }
}

fileprivate struct SampleFocusState: View {
    enum Field {
        case mobile
        case nickname
        case password
    }
    
    @State private var mobile = ""
    @State private var nickname = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?
    @State private var isValidToRegister = false
    
    var body: some View {
        VStack {
            Group {
                TextField("手机号", text: $mobile)
                    .focused($focusedField, equals: .mobile)
                TextField("昵称", text: $nickname)
                    .focused($focusedField, equals: .nickname)
                TextField("密码", text: $password)
                    .focused($focusedField, equals: .password)
            }
            .textFieldStyle(.roundedBorder)
            
            Button {
                if mobile.isEmpty {
                    focusedField = .mobile
                } else if nickname.isEmpty {
                    focusedField = .nickname
                } else if password.isEmpty {
                    focusedField = .password
                } else {
                    isValidToRegister = true
                    focusedField = nil
                }
            } label: {
                Text("注册")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .alert("注册成功", isPresented: $isValidToRegister) {}
        }
    }
}

fileprivate struct SampleFocusedValue: View {
    
    var body: some View {
        VStack {
            MemoInput()
            MemoPreview()
            BindingMemoInput()
            BindingMemoPreview()
        }
    }
    
    struct MemoInput: View {
        @State private var memo = "memo"
        
        var body: some View {
            TextField("memo", text: $memo)
                .textFieldStyle(.roundedBorder)
                .focusedValue(\.memo, memo)
        }
    }
    
    struct MemoPreview: View {
        @FocusedValue(\.memo) var memo
        
        var body: some View {
            Text(memo ?? "MemoInput is not focused now.")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
    
    struct BindingMemoInput: View {
        @State private var bindingMemo = "bindingMemo"
        
        var body: some View {
            TextField("bindingMemo", text: $bindingMemo)
                .textFieldStyle(.roundedBorder)
                .focusedValue(\.bindingMemo, $bindingMemo)
        }
    }
    
    struct BindingMemoPreview: View {
        @FocusedBinding(\.bindingMemo) var bindingMemo
        
        var body: some View {
            VStack(spacing: 10) {
                Text(bindingMemo ?? "BindingMemoInput is not focused now.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Button("Reset") {
                    bindingMemo = "bindingMemo"
                }
                .buttonStyle(.borderless)
            }
        }
    }
}

struct FocusedMemoValue: FocusedValueKey {
    typealias Value = String
}

extension FocusedValues {
    var memo: FocusedMemoValue.Value? {
        get { self[FocusedMemoValue.self] }
        set { self[FocusedMemoValue.self] = newValue }
    }
}

struct FocusedBindingMemo: FocusedValueKey {
    typealias Value = Binding<String>
}

extension FocusedValues {
    var bindingMemo: FocusedBindingMemo.Value? {
        get { self[FocusedBindingMemo.self] }
        set { self[FocusedBindingMemo.self] = newValue }
    }
}

fileprivate struct SampleCustomPropertyWrappers: View {
    @State private var text = ""
    @EncodedBase64 private var base64Text
    
    var body: some View {
        VStack(alignment: .leading) {
            LabeledContent("Input") {
                TextField("", text: $text)
                    .textFieldStyle(.roundedBorder)
                    .labelsHidden()
            }
            Text("Base64: \(base64Text)")
            BindingEncodedBase64View(base64Text: $base64Text)
        }
        .onChange(of: text) { newValue in
            base64Text = newValue
        }
    }
    
    struct BindingEncodedBase64View: View {
        @Binding var base64Text: String
        
        var body: some View {
            LabeledContent("Binding base64 text") {
                TextField("", text: $base64Text)
                    .textFieldStyle(.roundedBorder)
                    .labelsHidden()
            }
        }
    }
}

@propertyWrapper
fileprivate struct EncodedBase64: DynamicProperty {
    @State private var value: String = ""
    
    var wrappedValue: String {
        get {
            value
        }
        nonmutating set {
            value = newValue
                .data(using: .utf8)?
                .base64EncodedString() ?? "base64 is nil"
        }
    }
    
    var projectedValue: Binding<String> {
        .init {
            wrappedValue
        } set: {
            wrappedValue = $0
        }
    }
}

struct SamplePropertyWrappers_Previews: PreviewProvider {
    static var previews: some View {
        SamplePropertyWrappers()
    }
}

