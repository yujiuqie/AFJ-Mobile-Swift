//
//  asyncawaitView.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct AsyncAwaitView: View {
    @State private var img = UIImage()
    
    var body: some View {
        List {
            Section {
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } header: {
                Text("async/await")
            }
        }
        .listStyle(.insetGrouped)
        .task {
            img = await fetchImage()
        }
    }
    
    func fetchImage() async -> UIImage {
        let str = "https://images.pexels.com/photos/3652898/pexels-photo-3652898.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260"
        let url = URL(string: str)!
        let request = URLRequest(url: url)
        let res = try? await URLSession.shared.data(for: request)
        if let data = res?.0, let image = UIImage(data: data){
            return image
        }
        return UIImage()
    }
}

struct AsyncAwaitView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwaitView()
    }
}
