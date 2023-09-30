//
//  SampleList.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/27.
//

import SwiftUI

struct SampleList: View {
  
  var body: some View {
    Form {
      #if os(iOS)
      Section("绑定选中项") {
        NavigationLink("单选、多选") {
          SelectionList()
        }
      }
      #endif
      
      Section("可展开列表") {
        ExpandedList()
      }
      
      Section("样式") {
        NavigationLink("样式") {
          ListStyle()
        }
      }
      
      Section("交互") {
        NavigationLink("下拉刷新、搜索") {
          RefreshableAndSearchableList()
        }
        #if os(iOS)
        NavigationLink("编辑") {
          EditableList()
        }
        #endif
      }
    }
    .formStyle(.grouped)
  }
}

fileprivate struct ExpandedList: View {
  private let expandWeather: [ExpandWeather] = [
    ExpandWeather(name: "Weather", icon: "", weathers: [
      ExpandWeather(name: "Sunshine", icon: "sun.max.fill"),
      ExpandWeather(name: "Cloud", icon: "cloud"),
      ExpandWeather(name: "Snow", icon: "snow"),
      ExpandWeather(name: "Rain", icon: "cloud.rain.fill")
    ])
  ]
  
  var body: some View {
    List(expandWeather, children: \.weathers) { weather in
      if weather.icon.isEmpty {
        Text(weather.name)
      } else {
        Label(weather.name, systemImage: weather.icon)
      }
    }
  }
}

fileprivate struct ExpandWeather: Identifiable, Hashable {
  let id = UUID()
  var name: String
  var icon: String
  var weathers: [ExpandWeather]?
}

#if os(iOS)
fileprivate struct SelectionList: View {
  @State private var singleSelection: UUID?
  @State private var multiSelection = Set<UUID>()
  @State private var weathers = Weather.mock
  
  var body: some View {
    VStack {
      GroupBox("单选") {
        List(weathers, selection: $singleSelection) { v in
          Label(v.name, systemImage: v.icon)
            .foregroundColor(
              singleSelection == v.id
              ? .red
              : .primary
            )
        }
      }
      GroupBox("多选") {
        List(weathers, selection: $multiSelection) {
          Label($0.name, systemImage: $0.icon)
        }
      }
    }
    .toolbar {
      EditButton()
    }
  }
}
#endif

fileprivate struct ListStyle: View {
  @State private var listStyleType = ListStyleType.automatic
  
  var body: some View {
    switch listStyleType {
    case .automatic:
      list.listStyle(.automatic)
    case .inset:
      list.listStyle(.inset)
    case .plain:
      list.listStyle(.plain)
    case .sidebar:
      list.listStyle(.sidebar)
    #if os(macOS)
    case .bordered:
      list.listStyle(.bordered)
    case .borderedAlternates:
      list.listStyle(.bordered(alternatesRowBackgrounds: true))
    case .insetAlternates:
      list.listStyle(.inset(alternatesRowBackgrounds: true))
    #else
    case .grouped:
      list.listStyle(.grouped)
    case .insetGrouped:
      list.listStyle(.insetGrouped)
    #endif
    }
  }
  
  @ViewBuilder var list: some View {
    List {
      Section("Section 1") {
        ForEach(0..<5, id: \.self) { i in
          Text("Row \(i)")
            // 设置 listRow 边距
            .listRowInsets(.init(
              top: 0,
              leading: 100,
              bottom: 0,
              trailing: 0)
            )
            // 设置 listRow 背景
            .listRowBackground(
              LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              )
            )
            // 设置分割线颜色
            .listRowSeparatorTint(.white)
        }
      }
      
      Section("Section 2") {
        ForEach(0..<50, id: \.self) { i in
          Text("Row \(i)")
            // 设置角标，位于 listRow 右边
            // 可以使用数字，也可以自定义 Text
            // .badge(9)
             .badge(
              Text("Nine")
                .foregroundColor(.red)
                .bold()
                .italic()
             )
             // 隐藏分割线
             .listRowSeparator(.hidden)
        }
      }
      .textCase(nil)
    }
    // 设置 list 背景，需要和 scrollContentBackground 配合使用
    .background(.blue.gradient)
    .scrollContentBackground(.hidden)
    .safeAreaInset(edge: .bottom) {
      LabeledContent("listStyle") {
        Picker("listStyle", selection: $listStyleType) {
          ForEach(ListStyleType.allCases, id: \.self) {
            Text($0.rawValue)
          }
        }
        .labelsHidden()
      }
      .padding()
      .background(.bar)
    }
  }
}

fileprivate enum ListStyleType: String, CaseIterable {
  case automatic
  case inset
  case plain
  case sidebar
  #if os(macOS)
  case bordered
  case borderedAlternates
  case insetAlternates
  #else
  case grouped
  case insetGrouped
  #endif
}

fileprivate struct RefreshableAndSearchableList: View {
  @State private var weathers = Weather.mock
  @State private var searchText = ""
  
  private var searchResults: [Weather] {
    searchText.isEmpty
    ? weathers
    : weathers.filter  { $0.name.contains(searchText) }
  }
  
  var body: some View {
    List {
      ForEach(searchResults, id: \.id) {
        Label($0.name, systemImage: $0.icon)
      }
    }
    .refreshable {
      await fetch()
    }
    .searchable(
      text: $searchText,
      placement: searchFieldPlacement,
      prompt: "Input something..."
    )
    .searchSuggestions {
      ForEach(searchResults, id: \.self) { v in
        Text("Looking for \(v.name)?")
          .searchCompletion(v.name)
        Text("Looking for \(Image(systemName: v.icon))")
          .searchCompletion(v.name)
      }
    }
  }
  
  private var searchFieldPlacement: SearchFieldPlacement {
    #if os(iOS)
    .navigationBarDrawer(displayMode: .always)
    #else
    .toolbar
    #endif
  }
  
  func fetch() async {
    // 模拟异步操作
    try? await Task.sleep(for: .seconds(1))
    searchText = ""
    weathers = Bool.random() ? Weather.mock : Weather.mock.reversed()
  }
}

#if os(iOS)
fileprivate struct EditableList: View {
  @State private var weathers = Weather.mock
  
  var body: some View {
    List {
      ForEach(weathers, id: \.id) { v in
        Label(v.name, systemImage: v.icon)
      }
      .onDelete(perform: onDelete)
      .onMove(perform: onMove)
    }
    .toolbar {
      EditButton()
    }
  }
  
  func onDelete(offsets: IndexSet) {
    weathers.remove(atOffsets: offsets)
  }

  func onMove(fromOffsets: IndexSet, toOffset: Int) {
    weathers.move(fromOffsets: fromOffsets, toOffset: toOffset)
  }
}
#endif

struct SampleList_Previews: PreviewProvider {
  static var previews: some View {
    SampleList()
  }
}

