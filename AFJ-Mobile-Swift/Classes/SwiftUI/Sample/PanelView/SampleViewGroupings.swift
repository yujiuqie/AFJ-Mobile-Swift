//
//  SampleViewGroupings.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/20.
//

import SwiftUI

struct SampleViewGroupings: View {
    
    var body: some View {
        Form {
            Section("Group") {
                GroupView()
            }
            .textCase(nil)
            
            Section("GroupBox") {
                GroupBoxView()
            }
            .textCase(nil)
        }
        .formStyle(.grouped)
    }
}

fileprivate struct GroupView: View {
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                Group {
                    Text("0")
                    Text("1")
                    Text("2")
                    Text("3")
                    Text("4")
                    Text("5")
                    Text("6")
                    Text("7")
                    Text("8")
                    Text("9")
                }
                
                Divider()
                
                Group {
                    Text("A")
                    Text("B")
                    Text("C")
                    if Bool.random() {
                        Text("D")
                        Text("E")
                    }
                }
                .bold()
                .italic()
                .foregroundColor(.secondary)
            }
        }
    }
}

fileprivate struct GroupBoxView: View {
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                Label("iPhone", systemImage: "iphone")
                Label("Airpods Pro", systemImage: "airpodspro")
                Label("Apple Watch", systemImage: "applewatch")
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity, alignment: .leading)
        } label: {
            Label("Apple", systemImage: "applelogo")
                .italic()
                .foregroundColor(.blue)
        }
    }
}

struct SampleViewGroupings_Previews: PreviewProvider {
    static var previews: some View {
        SampleViewGroupings()
    }
}

