//
//  SampleMenuAndCommands.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleMenuAndCommands: View {
    @State private var state = ""
    @State private var selection = "Save"
    @State private var sync = true
    @State private var hasPrimaryAction = false
    @State private var picker1Selection = "Picker1 option 1"
    @State private var picker2Selection = "Picker2 option 1"
    @State private var hasContextPreview = false
    
    var body: some View {
        Form {
            Section {
                if hasPrimaryAction {
                    Menu {
                        menu
                    } label: {
                        menuLabel
                    } primaryAction: {
                        state = "primary action"
                    }
                } else {
                    Menu {
                        menu
                    } label: {
                        menuLabel
                    }
                }
                
                Toggle("primaryAction", isOn: $hasPrimaryAction)
            } header: {
                Text("Menu")
            } footer: {
                Text("Action：\(state)")
            }
            .textCase(nil)
            
            Section {
                if hasContextPreview {
                    Text("Context Menu")
                        .contextMenu {
                            contextMenu
                        } preview: {
                            Image(systemName: "swift")
                                .font(.system(size: 100))
                                .padding(30)
                        }
                } else {
                    Text("Context Menu")
                        .contextMenu {
                            contextMenu
                        }
                }
                
                Toggle("preview", isOn: $hasContextPreview)
            } header: {
                Text(".contextMenu")
            } footer: {
#if os(macOS)
                VStack(alignment: .trailing) {
                    Text("右键单击显示菜单")
                    Text("macOS 上不显示 preview，请在 iOS 上查看")
                }
#else
                Text("长按显示菜单")
#endif
            }
            .textCase(nil)
        }
        .formStyle(.grouped)
        .onChange(of: sync) { newValue in
            state = "Sync \(newValue ? "ON" : "OFF")"
        }
    }
    
    @ViewBuilder private var menu: some View {
        Group {
            Button {
                state = "Upload"
            } label: {
                Label("Upload", systemImage: "doc.badge.arrow.up")
            }
            
            Toggle(isOn: $sync) {
                Label("Sync", systemImage: "arrow.triangle.2.circlepath")
            }
            
            Section {
                Button {
                    state = "Collect"
                } label: {
                    Label("Collect", systemImage: "heart")
                }
                
                Button {
                    state = "Share"
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
            
            Menu {
                Button {
                    state = "Edit"
                } label: {
                    Label("Edit", systemImage: "square.and.pencil")
                }
                
                Button {
                    state = "Delete"
                } label: {
                    Label("Delete", systemImage: "minus.circle")
                }
            } label: {
                Label("More", systemImage: "ellipsis.circle")
            }
        }
    }
    
    @ViewBuilder private var menuLabel: some View {
        Label("Doc", systemImage: "doc.badge.ellipsis")
    }
    
    @ViewBuilder private var contextMenu: some View {
        Group {
            Button("Option 1") {}
            Picker("Picker 1", selection: $picker1Selection) {
                Text("Picker1 option 1").tag("Picker1 option 1")
                Text("Picker1 option 2").tag("Picker1 option 2")
            }
            Picker("Picker 2", selection: $picker2Selection) {
                Text("Picker2 option 1").tag("Picker2 option 1")
                Text("Picker2 option 2").tag("Picker2 option 2")
            }
            .pickerStyle(.menu)
        }
    }
}

struct SampleMenuAndCommands_Previews: PreviewProvider {
    static var previews: some View {
        SampleMenuAndCommands()
    }
}

