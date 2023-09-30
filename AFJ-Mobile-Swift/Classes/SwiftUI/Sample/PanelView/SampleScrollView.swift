//
//  SampleScrollView.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/27.
//

import SwiftUI

struct SampleScrollView: View {
  @State private var selection = ScrollBounceBehaviorStyle.automatic
  
  var body: some View {
    if #available(iOS 16.4, macOS 13.3, *) {
      content
        .scrollBounceBehavior(selection.behavior)
        .safeAreaInset(edge: .bottom) {
          LabeledContent(".scrollBounceBehavior") {
            Picker(".scrollBounceBehavior", selection: $selection) {
              ForEach(ScrollBounceBehaviorStyle.allCases, id: \.self) {
                Text($0.rawValue)
              }
            }
            .labelsHidden()
          }
          .padding()
          .background(.bar)
        }
    } else {
      content
    }
  }
  
  private var content: some View {
    Form {
      Group {
        Text("Hello")
        Text("World")
      }
      // 设置 item 背景
      .listRowBackground(Color.purple.opacity(0.3))
    }
    .formStyle(.grouped)
    // 设置滑动视图背景
    .background(.blue.gradient)
    // 隐藏系统内置的背景
    .scrollContentBackground(.hidden)
  }
}

fileprivate enum ScrollBounceBehaviorStyle: String, CaseIterable {
  case automatic
  case always
  case basedOnSize
  
  @available(iOS 16.4, macOS 13.3, *)
  var behavior: ScrollBounceBehavior {
    switch self {
    case .automatic:
      return .automatic
    case .always:
      return .always
    case .basedOnSize:
      return .basedOnSize
    }
  }
}

struct SampleScrollView_Previews: PreviewProvider {
  static var previews: some View {
    SampleScrollView()
  }
}

