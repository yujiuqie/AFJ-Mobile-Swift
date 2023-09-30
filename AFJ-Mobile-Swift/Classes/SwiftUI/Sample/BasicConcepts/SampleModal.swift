//
//  SampleSheet.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/17.
//

import SwiftUI

struct SampleModal: View, Identifiable {
    let id = UUID()
    public let name = "SampleModal"
    
    @State private var isPresented = false
    
    var body: some View {
        Form {
            Group {
                Section {
                    SampleSheet()
                } header: {
                    Text("Sheet")
                }
                
                Section {
                    SampleAlert()
                } header: {
                    Text("Alert")
                }
                
                Section {
                    SampleDialog()
                } header: {
                    Text("Dialog")
                }
            }
            .textCase(nil)
        }
        .formStyle(.grouped)
    }
}

// MARK: - Sheet

fileprivate struct VersionInfo: Identifiable {
    let id = UUID()
    var version: String
    var desc: String
}

fileprivate struct SampleSheet: View {
    @State private var isPresented = false
    @State private var versionInfo: VersionInfo?
    @State private var advancedSheetPresentation = false // iOS 16.4, macOS 13.3
    
    var body: some View {
        Button {
            isPresented.toggle()
        } label: {
            Text("sheet(isPresented:") +
            Text("onDismiss:").foregroundColor(.secondary) +
            Text("content:)")
        }
        .sheet(isPresented: $isPresented) {
            printLog("Dismissed")
        } content: {
            SheetView(isPresented: $isPresented)
        }
        
        Button {
            versionInfo = .init(version: "1.0.1", desc: "Bug fixes.")
        } label: {
            Text("sheet(item:") +
            Text("onDismiss:").foregroundColor(.secondary) +
            Text("content:)")
        }
        .sheet(item: $versionInfo) {
            printLog("Dismissed")
        } content: { versionInfo in
            Form {
                Section {
                    VStack(alignment: .leading) {
                        Text(versionInfo.version).bold()
                        Text(versionInfo.desc)
                    }
                } footer: {
                    Text("Tap to dismiss.")
                        .foregroundColor(.secondary)
                }
            }
            .formStyle(.grouped)
            .onTapGesture {
                self.versionInfo = nil
            }
        }
        
#if os(iOS)
        if #available(iOS 16.4, *) {
            if UIDevice.current.userInterfaceIdiom == .pad {
                Text("请在 iPhone (iOS 16.4) 上查看更富表现力的 sheet")
                    .foregroundColor(.secondary)
            } else {
                Button {
                    advancedSheetPresentation.toggle()
                } label: {
                    Text("AdvancedSheetPresentation\n") +
                    Text("`iOS 16.4/macOS 13.3`").foregroundColor(.secondary).font(.footnote)
                }
                .sheet(isPresented: $advancedSheetPresentation) {
                    AdvancedSheetPresentation()
                        .presentationCompactAdaptation(.fullScreenCover)
                }
            }
        } else {
            Text("升级至 iOS 16.4 查看更富表现力的 sheet")
                .foregroundColor(.secondary)
        }
#else
        Text("请在 iPhone (iOS 16.4) 上查看更富表现力的 sheet")
            .foregroundColor(.secondary)
#endif
    }
}

@available(iOS 16.4, macOS 13.3, *)
fileprivate struct AdvancedSheetPresentation: View {
    @State private var isPresented = false
    @Environment(\.dismiss) private var dismiss
    @State private var backgroundInteraction = BackgroundInteraction.enabled_upThrough
    @State private var compactAdaptation = CompactAdaptation.automatic
    @State private var cornerRadius: CGFloat?
    @State private var contentInteraction = ContentInteraction.resizes
    
    var body: some View {
        VStack {
            Group {
                Button("Sheet") {
                    isPresented.toggle()
                }
                Button("Dismiss") {
                    dismiss()
                }
            }
            .padding()
            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                LabeledContent("BackgroundInteraction") {
                    Picker("BackgroundInteraction", selection: $backgroundInteraction) {
                        ForEach(BackgroundInteraction.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .labelsHidden()
                }
                LabeledContent("ContentInteraction") {
                    Picker("ContentInteraction", selection: $contentInteraction) {
                        ForEach(ContentInteraction.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .labelsHidden()
                }
                LabeledContent("CompactAdaptation") {
                    Picker("CompactAdaptation", selection: $compactAdaptation) {
                        ForEach(CompactAdaptation.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .labelsHidden()
                }
            }
            .padding()
            .background(.bar)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow.gradient)
        .sheet(isPresented: $isPresented) {
            ScrollView {
                VStack {
                    Button("Dismiss") {
                        isPresented.toggle()
                    }
                    .padding()
                    
                    ForEach(0..<100, id: \.self) {
                        Text($0.formatted())
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
            }
            .presentationDetents([.height(200), .medium, .large])
            // 自定义背景
            .presentationBackground(.regularMaterial)
            // 设置背景的可交互性
            .presentationBackgroundInteraction(backgroundInteraction.value)
            // 设置 sheet 的交互
            .presentationContentInteraction(contentInteraction.value)
            // 设置在 compact size 上的尺寸
            .presentationCompactAdaptation(compactAdaptation.value)
            // 设置圆角
            .presentationCornerRadius(30)
        }
    }
    
    private enum BackgroundInteraction: String, CaseIterable {
        case automatic
        case disabled
        case enabled
        case enabled_upThrough
        
        var value: PresentationBackgroundInteraction {
            switch self {
            case .automatic:
                return .automatic
            case .disabled:
                return .disabled
            case .enabled:
                return .enabled
            case .enabled_upThrough:
                // 超过某个 detent 时，不可交互
                // 这里表示高度 <= 200 时可交互
                return .enabled(upThrough: .height(200))
            }
        }
    }
    
    private enum CompactAdaptation: String, CaseIterable {
        case automatic
        case none
        case fullScreenCover
        case popover
        case sheet
        
        var value: PresentationAdaptation {
            switch self {
            case .automatic:
                return .automatic
            case .none:
                return .none
            case .fullScreenCover:
                return .fullScreenCover
            case .popover:
                return .popover
            case .sheet:
                return .sheet
            }
        }
    }
    
    private enum ContentInteraction: String, CaseIterable {
        case automatic
        case resizes
        case scrolls
        
        var value: PresentationContentInteraction {
            switch self {
            case .automatic:
                return .automatic
            case .resizes:
                // 优先调整 sheet 尺寸
                return .resizes
                // 优先滑动
            case .scrolls:
                return .scrolls
            }
        }
    }
}

fileprivate struct SheetView: View {
    @Binding var isPresented: Bool
    @Environment(\.dismiss) var dismiss
    
#if os(iOS)
    @State private var selectedDetent = PresentationDetent.medium
    @State private var detents: [PresentationDetent] = [
        .medium,
        .large,
        .height(600),
        .fraction(0.33),
        .custom(CustomDetent.self)
    ]
    private let pickerData = [
        ".medium",
        ".large",
        ".height(600)",
        ".fraction(0.33)",
        ".custom(CustomDetent.self)"
    ]
#endif
    
    var body: some View {
        VStack(spacing: 20) {
#if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                Text("提示：在 iPhone 上体验 PresentationDetent")
                    .foregroundColor(.secondary)
            } else {
                Picker("PresentationDetent", selection: $selectedDetent) {
                    ForEach(pickerData.indices, id: \.self) { idx in
                        Text(pickerData[idx]).tag(detents[idx])
                    }
                }
                .pickerStyle(.menu)
            }
#else
            Text("提示：在 iPhone 上体验 PresentationDetent")
                .foregroundColor(.secondary)
#endif
            
            Button("isPresented") {
                isPresented.toggle()
            }
            
            Button("dismiss") {
                dismiss()
            }
        }
        .padding()
        .interactiveDismissDisabled()
#if os(iOS)
        .presentationDetents(Set(detents.map { $0 }), selection: $selectedDetent)
        .presentationDragIndicator(.visible)
#endif
    }
}

fileprivate struct CustomDetent: CustomPresentationDetent {
    
    static func height(in context: Context) -> CGFloat? {
        printLog(context.maxDetentValue)
        return min(750, context.maxDetentValue)
    }
}

// MARK: - Alert

fileprivate struct SampleAlert: View {
    @State private var isPresented1 = false
    @State private var isPresented2 = false
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        Button("Alert 1") {
            isPresented1.toggle()
        }
        .alert("Alert 1", isPresented: $isPresented1) {
            TextField("username", text: $username)
            TextField("password", text: $password)
            Button("Login") {}
        }
        
        Button("Alert 2") {
            isPresented2.toggle()
        }
        .alert("Alert 2", isPresented: $isPresented2) {
            Button("Cancel", role: .cancel) {
                
            }
            Button(role: .destructive) {
                
            } label: {
                Text("Hello")
            }
            Button("World") {}
        } message: {
            Text("Message..")
        }
    }
}

// MARK: - Dialog

fileprivate struct SampleDialog: View {
    @State private var isPresented = false
    
    var body: some View {
        Button("Confirm Dialog") {
            isPresented.toggle()
        }
        .confirmationDialog("Dialog", isPresented: $isPresented, titleVisibility: .visible) {
            Button(role: .cancel) {
                
            } label: {
                Text("取消")
            }
            
            Button("Option 1") {
                
            }
            
            Button(role: .destructive) {
                
            } label: {
                Text("Option 2")
            }
            
        } message: {
            Text("Message...")
        }
    }
}

struct SampleModal_Previews: PreviewProvider {
    static var previews: some View {
        SampleModal()
            .previewInterfaceOrientation(.portrait)
    }
}
