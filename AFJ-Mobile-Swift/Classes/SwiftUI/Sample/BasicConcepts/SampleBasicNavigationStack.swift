//
//  SampleBasicNavigationStack.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/16.
//

import SwiftUI

#if os(iOS)
struct SampleBasicNavigationStack: View, Identifiable {
    let id = UUID()
    public let name = "SampleBasicNavigationStack"
    
    // List 数据源
    @State private var imgName = "swift"
    @State private var numbers = [0, 1]
    
    /// 是否触发导航跳转
    @State private var isPresented = false
    
    /// iOS 导航栏标题样式
    @State private var navigationTitleStyles = NavigationTitleStyle.allCases
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(value: imgName) {
                        Image(systemName: imgName)
                    }
                    
                    ForEach(numbers, id: \.self) {
                        // value 为 nil 时，禁用跳转，样式也有所差异
                        NavigationLink("\($0)", value: $0 == 1 ? nil : $0)
                    }
                } header: {
                    Text("点击触发导航跳转")
                }
                
                Section {
                    Toggle("跳转", isOn: $isPresented)
                } header: {
                    Text("程序触发导航跳转")
                }
                
                Section {
                    NavigationLink {
                        Text("Hello") // destination
                    } label: {
                        Text("Hello")
                    }
                } header: {
                    Text("NavigationLink 指定 destination")
                        .textCase(nil)
                }
                
                Section {
                    ForEach(navigationTitleStyles, id: \.self) { value in
                        NavigationLink(value.description, value: value)
                    }
                } header: {
                    Text("导航栏标题样式")
                }
            }
            .navigationDestination(for: String.self) {
                Image(systemName: $0)
            }
            .navigationDestination(for: Int.self) {
                Text("\($0)")
            }
            .navigationDestination(isPresented: $isPresented) {
                Text("Hello")
            }
            .navigationDestination(for: NavigationTitleStyle.self) { value in
                ScrollView(.vertical) {
                    Text("Hello").padding()
                    if value == .large {
                        Text("上下滑动查看效果").foregroundColor(.secondary)
                    }
                }
                .navigationTitle(value.description)
                .navigationBarTitleDisplayMode(value)
            }
        }
    }
}

typealias NavigationTitleStyle = NavigationBarItem.TitleDisplayMode

extension NavigationTitleStyle: CaseIterable {
    
    public static var allCases: [NavigationBarItem.TitleDisplayMode] {
        [.automatic, .inline, .large]
    }
}

extension NavigationTitleStyle: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .automatic:
            return ".automatic"
        case .inline:
            return ".inline"
        case .large:
            return ".large"
        @unknown default:
            return "unknown mode"
        }
    }
}
#endif

struct SampleBasicNavigationStack_Previews: PreviewProvider {
    static var previews: some View {
        SampleBasicNavigationStack()
    }
}
