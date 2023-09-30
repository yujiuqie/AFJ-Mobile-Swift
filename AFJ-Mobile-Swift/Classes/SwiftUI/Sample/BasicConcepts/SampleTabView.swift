//
//  SampleTabView.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/16.
//

import SwiftUI

struct SampleTabView: View, Identifiable {
    let id = UUID()
    public let name = "SampleTabView"
    
    @State private var selection = 0
    @State private var tabStyle: TabStyle = .automatic
    
#if os(iOS)
    @State private var isShowTabItem = true
    
    init() {
        UIPageControl.appearance().pageIndicatorTintColor = .gray
        UIPageControl.appearance().currentPageIndicatorTintColor = .red
    }
#endif
    
    var body: some View {
        // AnyView 以及后面使用的 any 皆为通过编译之下策，尽量避免使用
        AnyView(
            TabView(selection: $selection) {
                Group {
#if os(iOS)
                    SampleHomeView(
                        tabSelection: $selection,
                        tabStyle: $tabStyle,
                        isShowTabItem: $isShowTabItem
                    )
#else
                    SampleHomeView(
                        tabSelection: $selection,
                        tabStyle: $tabStyle
                    )
#endif
                }
                .tabItem {
#if os(iOS)
                    if isShowTabItem {
                        Label("Home", systemImage: "house")
                    }
#else
                    Label("Home", systemImage: "house")
#endif
                }
                .tag(0)
#if os(iOS)
                .badge(isShowTabItem ? 99 : 0)
#endif
                
                Form {
                    TabSelectionView(tabSelection: $selection)
                }
                .formStyle(.grouped)
                .tabItem {
#if os(iOS)
                    if isShowTabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
#else
                    Label("Search", systemImage: "magnifyingglass")
#endif
                }
                .tag(1)
                
                Form {
                    TabSelectionView(tabSelection: $selection)
                }
                .formStyle(.grouped)
                .tabItem {
#if os(iOS)
                    if isShowTabItem {
                        Label("Settings", systemImage: "gear")
                    }
#else
                    Label("Settings", systemImage: "gear")
#endif
                }
                .tag(2)
#if os(iOS)
                .badge(isShowTabItem ? "Hi~" : nil)
#endif
            }
                .tabViewStyle(tabStyle.tabViewStyle)
        )
    }
}

fileprivate struct SampleHomeView: View {
    @Binding var tabSelection: Int
    @Binding var tabStyle: TabStyle
    
#if os(iOS)
    @Binding var isShowTabItem: Bool
    @State private var isPresented = false
    
    @State private var pageStyle: PageStyle = .automatic {
        didSet {
            tabStyle = .page_indexDisplayMode(pageStyle)
            // replace `.page_indexDisplayMode`
            tabStyles = tabStyles.map {
                ($0 != .page && $0 != .automatic) ? tabStyle : $0
            }
            printLog(tabStyle)
        }
    }
    
    @State var tabStyles: [TabStyle] = TabStyle.allCases
#endif
    
    var body: some View {
        Form {
            Section {
#if os(macOS)
                Picker("TabViewStyle", selection: $tabStyle) {
                    ForEach(TabStyle.allCases, id: \.self) { style in
                        Text(style.name)
                    }
                }
                .labelsHidden()
#else
                ForEach(tabStyles, id: \.self) { style in
                    ItemButton(text: style.name, opacity: tabStyle == style ? 1 : 0) {
                        tabStyle = style
                    }
                }
#endif
            } header: {
                Text("TabViewStyle")
                    .textCase(nil)
            } footer: {
#if os(macOS)
                Text("iPhone、iPad 上查看更多 TabViewStyle 样式")
                    .foregroundColor(.secondary)
#endif
            }
            
#if os(iOS)
            if case .page_indexDisplayMode(let pageStyle) = tabStyle {
                Section {
                    // `type(of: pageStyle)` is `PageStyle`
                    ForEach(type(of: pageStyle).allCases, id: \.self) { v in
                        ItemButton(text: v.rawValue, opacity: self.pageStyle == v ? 1 : 0) {
                            self.pageStyle = v
                        }
                    }
                } header: {
                    Text("Page Style")
                }
            }
#endif
            
            Section {
                Picker("Tab Selection", selection: $tabSelection) {
                    ForEach(0..<3, id: \.self) {
                        Text("\($0)")
                    }
                }
                .labelsHidden()
            } header: {
                Text("Tab Selection")
                    .textCase(nil)
            }
            
#if os(iOS)
            Section {
                Toggle("Show tabItem", isOn: $isShowTabItem)
            }
            
            Section {
                Button("自定义 TabView") {
                    isPresented.toggle()
                }
            }
#else
            HStack {
                Text("自定义 TabView：").bold()
                PlatformTipsView()
            }
#endif
        }
        .formStyle(.grouped)
        .pickerStyle(.inline)
#if os(iOS)
        .sheet(isPresented: $isPresented) {
            MainTabView()
        }
#endif
    }
}

fileprivate struct ItemButton: View {
    let text: String
    let opacity: Double
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(text)
                Spacer()
                Image(systemName: "checkmark.seal")
                    .foregroundColor(.blue)
                    .opacity(opacity)
            }
        }
        .foregroundColor(.primary)
        .buttonStyle(.borderless)
    }
}

fileprivate struct TabSelectionView: View {
    @Binding var tabSelection: Int
    
    var body: some View {
        Picker("Tab Selection", selection: $tabSelection) {
            ForEach(0..<3, id: \.self) {
                Text("\($0)").tag($0)
            }
        }
#if os(iOS)
        .padding()
        .pickerStyle(.segmented)
#else
        .pickerStyle(.inline)
#endif
    }
}

fileprivate enum TabStyle: CaseIterable, Hashable {
    static var allCases: [TabStyle] {
#if os(macOS)
        return [.automatic]
#else
        return [.automatic, .page, .page_indexDisplayMode(.automatic)]
#endif
    }
    
    case automatic
#if os(iOS)
    case page
    case page_indexDisplayMode(PageStyle)
#endif
    
    var name: String {
        switch self {
        case .automatic:
            return "automatic"
#if os(iOS)
        case .page:
            return "page"
        case .page_indexDisplayMode(_):
            return "page(indexDisplayMode:)"
#endif
        }
    }
    
    var tabViewStyle: any TabViewStyle {
        switch self {
        case .automatic:
            return .automatic
#if os(iOS)
        case .page:
            return .page
        case let .page_indexDisplayMode(v):
            return .page(indexDisplayMode: v.pageStyle)
#endif
        }
    }
}

#if os(iOS)
fileprivate enum PageStyle: String, CaseIterable {
    case automatic = "automatic"
    case always = "always"
    case never = "never"
    
    var pageStyle: PageTabViewStyle.IndexDisplayMode {
        switch self {
        case .automatic:
            return PageTabViewStyle.IndexDisplayMode.automatic
        case .always:
            return .always
        case .never:
            return .never
        }
    }
}
#endif

struct SampleTabView_Previews: PreviewProvider {
    static var previews: some View {
        SampleTabView()
    }
}

