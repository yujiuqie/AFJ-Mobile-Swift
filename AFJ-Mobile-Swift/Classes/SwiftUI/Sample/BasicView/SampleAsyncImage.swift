//
//  SampleAsyncImage.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleAsyncImage: View {
    private let url = URL(string: "https://images.pexels.com/photos/3652898/pexels-photo-3652898.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260")!
    private let size: CGFloat = 200
    
    @State private var clipped = false
    @State private var resizable = true
    
    @State private var status = ""
    
    var body: some View {
        Form {
            Section("加载远程图片") {
                AsyncImage(url: url) { image in
                    image
                    // 条件渲染，源码见 Extensions
                        .if(resizable) { view in
                            view.resizable()
                        }
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    // 自定义 placeholder
                    Color.gray.opacity(0.3)
                        .overlay(ProgressView())
                }
                .frame(width: size, height: size)
                .border(Color.purple, width: 3)
                .if(clipped) { view in
                    view.clipped()
                }
                // 设置圆角会自动裁剪，无需显示指定 clipped
                // .cornerRadius(cornerRadius)
                .frame(maxWidth: .infinity)
                
                Toggle("resizable", isOn: $resizable)
                Toggle("clipped", isOn: $clipped)
            }
            
            Section("状态监听、动画") {
                AsyncImage(
                    url: url,
                    // 动画
                    transaction: .init(animation: .default)
                ) { phase in
                    switch phase {
                        // 图片未下载
                    case .empty:
                        ProgressView()
                        // 图片未下载
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                            .transition(
                                .move(edge: .top)
                                .combined(with: .opacity)
                            )
                        // 图片下载失败
                    case .failure(_):
                        Image(systemName: "xmark.circle")
                    @unknown default:
                        Image(systemName: "xmark.circle")
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .formStyle(.grouped)
    }
}

struct SampleAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        SampleAsyncImage()
    }
}
