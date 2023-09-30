//
//  SampleImageRenderer.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleImageRenderer: View {
    @State private var snapshot: Image?
    @Environment(\.displayScale) private var displayScale
    
    var body: some View {
        VStack {
            content
            VStack {
                Button("Snap shot") {
                    createSnapshot()
                }
                Divider()
                
                Text("以下是生成的图片")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                if let snapshot {
                    snapshot
                } else {
                    ProgressView()
                }
            }
        }
    }
    
    private var content: some View {
        Label("Apple", systemImage: "apple.logo")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(
                .linearGradient(
                    colors: [.red, .pink, .green, .blue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .padding()
            .background(Color.black.gradient)
            .cornerRadius(10)
            .shadow(radius: 10)
    }
    
    @MainActor private func createSnapshot() {
        let renderer = ImageRenderer(content: content)
        // 设置分辨率，默认为 1.0
        // 这里从环境变量获取当前屏幕分辨率
        renderer.scale = displayScale
        if let uiImage = renderer.uiImage {
            snapshot = .init(uiImage: uiImage)
        }
        
        //        let trophyAndDate = createAwardView(forUser: "playerName",
        //                                            date: Date())
        //        let renderer = ImageRenderer(content: trophyAndDate)
        //        if let image = renderer.cgImage {
        //            snapshot = .init(uiImage: UIImage(cgImage: image))
        //        }
    }
    
    private func createAwardView(forUser: String, date: Date) -> some View {
        VStack {
            Image(systemName: "trophy")
                .resizable()
                .frame(width: 200, height: 200)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .shadow(color: .mint, radius: 5)
            Text("playerName")
                .font(.largeTitle)
            Text(Date().formatted())
        }
        .multilineTextAlignment(.center)
        .frame(width: 200, height: 290)
    }
}

struct SampleImageRenderer_Previews: PreviewProvider {
    static var previews: some View {
        SampleImageRenderer()
        //      .preferredColorScheme(.dark)
    }
}

