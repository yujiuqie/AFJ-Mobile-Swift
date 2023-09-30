//
//  SampleBridgingUIKit.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI
import SafariServices

struct SampleBridgingUIKit: View {
    @State private var searchText: String = ""
    @State private var showSafari = false
    
    var body: some View {
        Form {
#if os(iOS)
            Section {
                SearchBarView(searchText: $searchText)
            } header: {
                Text("UIViewRepresentable")
            } footer: {
                Text(searchText)
            }
            .textCase(nil)
            
            Section("UIViewControllerRepresentable") {
                Button("Apple") {
                    showSafari.toggle()
                }
                .sheet(isPresented: $showSafari) {
                    SafariView(url: .init(string: "https://apple.com")!)
                }
            }
            .textCase(nil)
#else
            Text("请在 iOS 上查看示例")
#endif
        }
        .formStyle(.grouped)
    }
}

#if os(iOS)
struct SearchBarView: UIViewRepresentable {
    @Binding var searchText: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        var searchBarView: SearchBarView
        
        init(_ searchBarView: SearchBarView) {
            self.searchBarView = searchBarView
        }
        
        func searchBar(
            _ searchBar: UISearchBar,
            textDidChange searchText: String
        ) {
            searchBarView.searchText = searchText
        }
        
        func searchBarSearchButtonClicked(
            _ searchBar: UISearchBar
        ) {
            searchBar.endEditing(true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let uiView = UISearchBar()
        uiView.placeholder = "Input something..."
        uiView.searchBarStyle = .minimal
        uiView.delegate = context.coordinator
        return uiView
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = searchText
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(
        context: Context
    ) -> SFSafariViewController {
        let controller = SFSafariViewController(url: url)
        return controller
    }
    
    func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: Context
    ) {
        
    }
}
#endif

struct SampleBridgingUIKit_Previews: PreviewProvider {
    static var previews: some View {
        SampleBridgingUIKit()
    }
}

