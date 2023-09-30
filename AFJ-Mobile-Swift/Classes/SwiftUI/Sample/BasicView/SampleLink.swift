//
//  SampleLink.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleLink: View {
    private let appleURL: URL = .init(string: "https://apple.com")!
    private let person = Person(
        name: "zzzwco",
        avatar: "parrot_small"
    )
    
    var body: some View {
        Form {
            Group {
                Section("Link") {
                    LabeledContent("字符串构建") {
                        Link("apple.com", destination: appleURL)
                            .italic()
                    }
                    
                    LabeledContent("view 构建") {
                        Link(destination: appleURL) {
                            Label("apple", systemImage: "applelogo")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                Section("ShareLink") {
                    Group {
                        LabeledContent("默认分享链接") {
                            ShareLink(item: appleURL)
                        }
                        
                        LabeledContent("自定义分享链接") {
                            ShareLink(
                                item: appleURL,
                                subject: Text("I'm a subject"),
                                message: Text("I'm a message")) {
                                    Label("apple", systemImage: "applelogo")
                                        .foregroundColor(.red)
                                }
                        }
                        
                        LabeledContent("分享图片") {
                            ShareLink(
                                item: Image("parrot_small"),
                                preview: SharePreview(
                                    "parrot",
                                    image: Image("parrot_small")
                                )
                            )
                        }
                        
                        LabeledContent("自定义分享内容") {
                            ShareLink(
                                item: person,
                                preview: SharePreview(
                                    person.name,
                                    image: person.image
                                )
                            )
                        }
                    }
                    .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                }
            }
            .textCase(nil)
        }
        .formStyle(.grouped)
    }
}

fileprivate struct Person: Codable {
    var name: String
    var avatar: String
}

extension Person: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.image)
    }
    
    var image: Image {
        .init(avatar)
    }
}

struct SampleLink_Previews: PreviewProvider {
    static var previews: some View {
        SampleLink()
    }
}

