//
//  AFJCaseItemData.swift
//  AFJ-iOS-Swift
//
//  Created by alfred on 2022/11/19.
//

import Foundation

class AFJCaseItem: NSObject {
    var title: String = ""
    var callback: ((_ caseItem: AFJCaseItem) -> Void)?
    
    init(title: String, callback: ( (_: AFJCaseItem) -> Void)? = nil) {
        self.title = title
        self.callback = callback
        super.init()
    }
}
