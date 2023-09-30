//
//  SampleTintColor.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/16.
//

import SwiftUI

struct SampleTintColor: View, Identifiable {
    let id = "SampleTintColor"
    public let name = "SampleTintColor"
    
    /// `@State` 是 SwiftUI 中的一个属性包装器，
    /// 将其修饰的变量值绑定至相应的视图，
    /// 当变量的值发生改变时，相应的视图也会更新。
    ///
    /// 这里的 `isOn` 就和视图中的开关进行了绑定，
    /// 当开关状态变化时，当前界面的主题色会随之变化。
    @State private var isOn = false
    
    /// 当前视图的主题色，默认为工程设置的 AccentColor。
    /// 如果打开开关，会变成如下代码设置的 `.orange`。
    @State private var tintColor: Color = .accentColor
    
    var body: some View {
        Form {
            Toggle("使用指定主题色", isOn: $isOn)
            
            Section {
                HStack {
                    Text("Swift")
                    Spacer()
                    Image(systemName: "swift")
                        .foregroundColor(tintColor)
                }
            } footer: {
                Text("这是一个文本、一个图片")
            }
            
            Section {
                Button("这是一个按钮") {}
            }
            
            Section {
                Link(destination: .init(string: "https://www.apple.com")!) {
                    Label("Apple", systemImage: "applelogo")
                }
            } footer: {
                Text("这是一个链接")
            }
        }
        .formStyle(.grouped)
        .tint(tintColor)
        .onChange(of: isOn) { newValue in // 监听 toggle 开关状态
            tintColor = newValue ? .orange : .accentColor
        }
    }
}

struct SampleTintColor_Previews: PreviewProvider {
    static var previews: some View {
        SampleTintColor().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
