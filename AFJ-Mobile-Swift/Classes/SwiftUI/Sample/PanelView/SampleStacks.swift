//
//  SampleStacks.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/20.
//

import SwiftUI

struct SampleStacks: View {
    
    var body: some View {
        Form {
            Section("HStack") {
                SampleHStack()
            }
            .textCase(nil)
            
            Section("LazyHStack") {
                SampleLazyHStack()
            }
            .textCase(nil)
            
            NavigationLink("LazyVStack") {
                SampleLazyVStack()
            }
        }
        .formStyle(.grouped)
    }
}

fileprivate struct SampleHStack: View {
    private let colors: [Color] = [
        .red, .orange, .green, .blue, .purple
    ]
    private let hAligments: [String : VerticalAlignment] = [
        "top" : .top,
        "center" : .center,
        "bottom" : .bottom,
    ]
    @State private var hAlignmentSelection = "center"
    @State private var hSpacing: CGFloat = 8
    
    var body: some View {
        HStack(
            alignment: hAligments[hAlignmentSelection]!,
            spacing: hSpacing
        ) {
            colorsView
                .animation(.default, value: hAlignmentSelection)
                .animation(.spring(), value: hSpacing)
        }
        .frame(maxWidth: .infinity)
        
        LabeledContent("alignment") {
            Picker("", selection: $hAlignmentSelection) {
                ForEach(Array(hAligments.keys), id: \.self) {
                    Text($0).tag($0)
                }
            }
        }
        
        LabeledContent("spacing") {
            Slider(value: $hSpacing, in: -10...12)
        }
    }
    
    var colorsView: some View {
        let wh: (Int) -> CGFloat = { index in
            let count = colors.count
            let index = index <= count / 2 ? index : count - 1 - index
            return CGFloat(44 + index * 8)
        }
        return ForEach(0..<colors.count, id: \.self) { index in
            colors[index]
                .frame(width: wh(index), height: wh(index))
                .cornerRadius(wh(index) * 0.1)
        }
    }
}

fileprivate struct SampleLazyHStack: View {
    private let countries = Countries().all
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(pinnedViews: .sectionHeaders) {
                ForEach(countries, id: \.self) { section in
                    Section {
                        ForEach(section.countires, id: \.self) {
                            Text($0)
                        }
                    } header: {
                        Text(section.name)
                            .padding(5)
                            .background(.ultraThickMaterial)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.primary)
                            )
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

fileprivate struct SampleLazyVStack: View {
    private let countries = Countries().all
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(pinnedViews: [.sectionHeaders, .sectionFooters]) {
                ForEach(countries, id: \.self) { section in
                    Section {
                        ForEach(section.countires, id: \.self) {
                            Text($0)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    } header: {
                        Text(section.name)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.bar)
                            .overlay(alignment: .bottom) {
                                Divider()
                            }
                    } footer: {
                        Text("I'm a footer")
                            .padding()
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.bar)
                    }
                }
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct SampleStacks_Previews: PreviewProvider {
    static var previews: some View {
        SampleStacks()
    }
}
