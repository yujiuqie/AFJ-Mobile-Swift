//
//  AFJFileModel.swift
//  AFJ-iOS-Swift
//
//  Created by alfred on 2022/12/9.
//

import Foundation

struct AFJFileModel {
    ///完整路径
    var path = ""
    ///是否文件夹
    var isDirectory = false
    
    init(_ path: String, isDirectory: Bool) {
        self.path = path
        self.isDirectory = isDirectory
    }
}
