//
//  MainSwiftViewController.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/9/17.
//

import UIKit
import SwiftUI

// 遵循UIViewControllerRepresentable协议
struct SwiftUICallSwift: UIViewControllerRepresentable {
    var color : UIColor?
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = MainSwiftViewController()
        vc.color = color
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}

// SwiftUI（此处的作用是为了设置导航，如果直接从上个页面push到MainSwiftViewController，导航返回按钮点击将无效）
struct TestTempVC: View {
    @Environment(\.presentationMode) var presentationMode
    @State var color : UIColor?
    
    var body: some View{
        VStack{
            SwiftUICallSwift(color: color)
        }.navigationBarTitle("MainSwiftViewController", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image("nav_back_black")
            }))
    }
}

class MainSwiftViewController: UIViewController {
    
    var color : UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = color ?? .orange
        
        self.title = "TestVC"
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        label.textAlignment = .center
        label.center = self.view.center
        label.text = "这是一个Swift的ViewController"
        self.view.addSubview(label)
        
    }
    
}
