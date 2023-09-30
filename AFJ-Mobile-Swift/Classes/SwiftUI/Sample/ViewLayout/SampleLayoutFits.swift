//
//  SampleLayoutFits.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/20.
//

import SwiftUI

struct SampleLayoutFits: View {
    
    var body: some View {
        Form {
#if os(iOS)
            Section("根据屏幕自适应") {
                SizeClassView()
            }
            .textCase(nil)
#endif
            
            Section("根据尺寸自适应"){
                ViewThatFitsView()
            }
            .textCase(nil)
            
            Section{
                ViewThatFitsView2()
            } footer: {
#if os(macOS)
                Text("调整窗口大小，布局自动切换")
#else
                Text("横屏和竖屏时，布局自动切换")
#endif
            }
        }
        .formStyle(.grouped)
    }
}

#if os(iOS)
fileprivate struct SizeClassView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        if horizontalSizeClass == .compact {
            VStack(alignment: .leading) {
                content
            }
        } else {
            HStack {
                content
            }
        }
    }
    
    var content: some View {
        Group {
            Label("Swift", systemImage: "swift")
            Label("Apple", systemImage: "applelogo")
        }
    }
}
#endif

fileprivate struct ViewThatFitsView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            UploadProgressView(uploadProgress: 0.75)
                .frame(maxWidth: 200)
                .border(.red)
            UploadProgressView(uploadProgress: 0.75)
                .frame(maxWidth: 100)
                .border(.red)
            UploadProgressView(uploadProgress: 0.75)
                .frame(maxWidth: 50)
                .border(.red)
        }
    }
}

fileprivate struct UploadProgressView: View {
    @State var uploadProgress: Double
    
    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack {
                Text("\(uploadProgress.formatted(.percent))")
                ProgressView(value: uploadProgress)
                    .frame(width: 100)
            }
            ProgressView(value: uploadProgress)
                .frame(width: 100)
            Text("\(uploadProgress.formatted(.percent))")
        }
    }
}

fileprivate struct ViewThatFitsView2: View {
    
    var body: some View {
        ViewThatFits {
            HStack {
                Color.red
                    .frame(minWidth: 300, minHeight: 100)
                Color.blue
                    .frame(minWidth: 300, minHeight: 100)
            }
            VStack {
                Color.red
                    .frame(minWidth: 300, minHeight: 100)
                Color.blue
                    .frame(minWidth: 300, minHeight: 100)
            }
        }
    }
}

struct SampleLayoutFits_Previews: PreviewProvider {
    static var previews: some View {
        SampleLayoutFits()
    }
}

