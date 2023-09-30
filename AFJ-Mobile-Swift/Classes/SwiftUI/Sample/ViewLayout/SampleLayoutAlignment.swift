//
//  SampleLayoutAlignment.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/20.
//

import SwiftUI

struct SampleLayoutAlignment: View {
    
    var body: some View {
        Form {
            Section("内置 alignmentGuide") {
                BuiltInAlignmentGuide()
            }
            .textCase(nil)
            
            Section("调整 alignmentGuide") {
                AdjustmentAlignmentGuide()
            }
            .textCase(nil)
            
            Section("自定义 alignmentGuide") {
                CustomAlignmentGuide()
            }
            .textCase(nil)
        }
        .formStyle(.grouped)
    }
}

fileprivate struct BuiltInAlignmentGuide: View {
    
    var body: some View {
        Label("Swift", systemImage: "swift")
            .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
        Label("Apple", systemImage: "applelogo")
    }
}

fileprivate struct AdjustmentAlignmentGuide: View {
    
    var body: some View {
        HStack(alignment: .top) {
            Rectangle()
                .frame(width: 50, height: 50)
            Rectangle()
                .frame(width: 50, height: 50)
                .alignmentGuide(.top) { d in -d.height * 0.5 }
            Rectangle()
                .frame(width: 50, height: 50)
            Rectangle()
                .frame(width: 50, height: 50)
                .alignmentGuide(.top) { d in -d.height * 0.5 }
        }
        
        VStack(alignment: .leading) {
            Rectangle()
                .frame(width: 50, height: 50)
            Rectangle()
                .frame(width: 50, height: 50)
                .alignmentGuide(.leading) { _ in -50 }
            Rectangle()
                .frame(width: 50, height: 50)
                .alignmentGuide(.leading) { _ in -100 }
            Rectangle()
                .frame(width: 50, height: 50)
                .alignmentGuide(.leading) { _ in -150 }
        }
    }
}

fileprivate struct CustomAlignmentGuide: View {
    var body: some View {
        VStack(alignment: .custom) {
            HStack {
                Text("手机")
                    .alignmentGuide(.custom) { $0[.trailing] }
                Text("155********")
            }
            
            HStack {
                Text("电子邮箱")
                    .alignmentGuide(.custom) { $0[.trailing] }
                Text("xxxxxx@gmail.com")
            }
        }
    }
}

fileprivate extension HorizontalAlignment {
    struct CustomAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[.trailing]
        }
    }
    
    static let custom = HorizontalAlignment(CustomAlignment.self)
}

struct SampleLayoutAlignment_Previews: PreviewProvider {
    static var previews: some View {
        SampleLayoutAlignment()
    }
}

