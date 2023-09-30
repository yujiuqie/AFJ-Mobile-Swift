//
//  TipsView.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/16.
//

import SwiftUI

struct TipsView: View {
    
    let iOSTips: String
    let macOSTips: String
    
    init(iOSTips: String = "", macOSTips: String = "") {
        self.iOSTips = iOSTips
        self.macOSTips = macOSTips
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: systemImageName)
            Text(tips)
        }
    }
    
    private var systemImageName: String {
#if os(iOS)
        "ipad.and.iphone"
#elseif os(macOS)
        "desktopcomputer"
#endif
    }
    
    private var tips: String {
#if os(iOS)
        iOSTips
#elseif os(macOS)
        macOSTips
#endif
    }
}
