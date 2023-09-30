//
//  SampleToolbars.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/17.
//

import SwiftUI

struct SampleToolbars: View {
    @State private var pickerSelection = 0
    @State private var isOn = true
    @State private var placement: Placement = .automatic
    @State private var colorScheme = ColorScheme.light
    @State private var isVisibility = true
    
    var body: some View {
        /**
         ⚠️ 经测试，NavigationStack 的嵌套在部分系统上会导致程序异常
         copy 代码后运行，需要打开注释才能看到导航栏效果
         */
        NavigationStack {
            Form {
                Picker("Placement", selection: $placement) {
                    ForEach(Placement.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                Picker("ColorScheme", selection: $colorScheme) {
                    ForEach(ColorScheme.allCases, id: \.self) { v in
                        Text(v == .light ? "light" : "dark")
                    }
                }
                Toggle("Visibility", isOn: $isVisibility)
            }
            .formStyle(.grouped)
            .navigationTitle("Title")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
                ToolbarItemGroup(placement: groupPlacement) {
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    
                    Menu {
                        Button("Menu 1") {}
                        Button("Menu 2") {}
                    } label: {
                        Image(systemName: "pencil")
                    }
                }
                
#if os(iOS)
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Title").bold()
                        Text("Subtitle").font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                
                ToolbarItemGroup(placement: .bottomBar) {
                    HStack {
                        Button("Left") {}
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Button("Medium") {}
                            .frame(maxWidth: .infinity, alignment: .center)
                        Button("Right") {}
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
#endif
            }
            .toolbarTitleMenu { // 只在 iOS、iPadOS 有效
                Button("Button 1") {}
                Button("Button 2") {}
                Picker("Picker", selection: $pickerSelection) {
                    ForEach(0..<2, id: \.self) {
                        Text("\($0)")
                    }
                }
                Menu("Menu") {
                    Button("Menu 1") {}
                    Button("Menu 2") {}
                }
                Section {
                    Toggle("Toggle", isOn: $isOn)
                }
            }
            .toolbarColorScheme(colorScheme, for: placement.place)
            .toolbar(isVisibility ? .visible : .hidden, for: placement.place)
#if os(iOS)
            .toolbarBackground(.yellow, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
#elseif os(macOS)
            .toolbarBackground(.linearGradient(
                colors: [.blue, .purple],
                startPoint: .leading,
                endPoint: .trailing), for: placement.place)
#endif
        }
    }
    
    var groupPlacement: ToolbarItemPlacement {
#if os(iOS)
        .navigationBarTrailing
#else
        .primaryAction
#endif
    }
}

fileprivate enum Placement: String, CaseIterable {
    case automatic = "automatic"
#if os(iOS)
    case bottomBar = "bottomBar"
    case navigationBar = "navigationBar"
#else
    case windowToolbar = "windowToolbar"
#endif
    
    var place: ToolbarPlacement {
        switch self {
        case .automatic:
            return .automatic
#if os(iOS)
        case .bottomBar:
            return .bottomBar
        case .navigationBar:
            return .navigationBar
#else
        case .windowToolbar:
            return .windowToolbar
#endif
        }
    }
}

struct SampleToolbars_Previews: PreviewProvider {
    static var previews: some View {
        SampleToolbars()
    }
}

