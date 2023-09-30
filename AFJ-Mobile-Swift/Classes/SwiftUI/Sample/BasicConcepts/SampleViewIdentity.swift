//
//  SampleViewIdentity.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/17.
//

import SwiftUI

struct SampleViewIdentity: View {
  
  @State private var value = 30.0
  private let rangeMin = 0
  private let rangeMax = 50
  
  var body: some View {
    // ScrollViewReader 返回一个 ScrollViewProxy 实例，即 proxy
    // proxy 通过 scrollTo 方法（传入视图 id）跳转至指定视图
    ScrollViewReader { proxy in
      HStack {
        Slider(
          value: $value,
          in: Double(rangeMin)...Double(rangeMax - 1)
        ) {
          Text("HELLO")
        } minimumValueLabel: {
          Text("\(rangeMin)")
        } maximumValueLabel: {
          Text("\(rangeMax - 1)")
        }
        
        Button("Jump to \(Int(value))") {
          withAnimation {
            proxy.scrollTo(Int(value))
          }
        }
      }
      
      ScrollView {
        ForEach(rangeMin..<rangeMax, id: \.self) {
          Text("\($0)")
            .padding()
            .frame(maxWidth: .infinity)
        }
      }
    }
    .padding()
  }
}

struct SampleViewIdentity_Previews: PreviewProvider {
    static var previews: some View {
        SampleViewIdentity()
    }
}
