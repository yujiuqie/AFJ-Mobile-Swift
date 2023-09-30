//
//  SampleCustomView.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleCustomView: View {
    @State private var isHorizontal = true
    
    var body: some View {
        Form {
            Section("自定义 view") {
                LabeledContent {
                    VLabel(
                        image: .init(systemName: "swift"),
                        text: "Swift"
                    )
                } label: {
                    Text("VLabel")
                }
                
                LabeledContent {
                    buttonOrText
                } label: {
                    Text("buttonOrText")
                }
                
                VStack {
                    LabeledContent {
                        VStack {
                            HVStack(
                                axis: isHorizontal
                                ? .horizontal
                                : .vertical
                            ) {
                                if isHorizontal {
                                    Image(systemName: "bold")
                                    Image(systemName: "italic")
                                    Image(systemName: "underline")
                                } else {
                                    Text("加粗")
                                    Text("斜体")
                                    Text("下划线")
                                }
                            }
                        }
                    } label: {
                        Text("HVStack")
                    }
                    
                    Toggle("isHorizontal", isOn: $isHorizontal)
                }
            }
            .textCase(nil)
            
            Section("自定义 Modifier") {
                HStack {
                    Text("Hello").modifier(CardStyle())
                    Image(systemName: "applelogo").cardStyle()
                    ProgressView().cardStyle()
                }
            }
            .textCase(nil)
        }
        .formStyle(.grouped)
    }
    
    @ViewBuilder var buttonOrText: some View {
        if Bool.random() {
            Button("I'm a button") {}
                .buttonStyle(.borderless)
        } else {
            Text("I'm a text")
        }
    }
}

fileprivate struct VLabel: View {
    let image: Image
    let text: String
    
    var body: some View {
        VStack {
            image
            Text(text)
        }
    }
}

fileprivate struct HVStack<Content: View>: View {
    private let axis: Axis
    private let content: () -> Content
    
    //  let axis: Axis
    //  @ViewBuilder let content: () -> Content
    
    init(
        axis: Axis,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.axis = axis
        self.content = content
    }
    
    var body: some View {
        if axis == .horizontal {
            HStack {
                content()
            }
        } else {
            VStack {
                content()
            }
        }
    }
}

fileprivate struct CardStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(30)
            .background(.regularMaterial)
            .cornerRadius(10)
            .shadow(radius: 8)
    }
}

fileprivate extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}


struct SampleCustomView_Previews: PreviewProvider {
    static var previews: some View {
        SampleCustomView()
    }
}

