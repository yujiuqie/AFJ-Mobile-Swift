//
//  AFJProduct.swift
//  AFJ-iOS-Swift
//
//  Created by alfred on 2022/11/18.
//

import Foundation

struct AFJProduct: Codable {
    var title: String
    var entrance: String
    var hasDemo: String
    var link: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case entrance = "entrance"
        case hasDemo = "hasDemo"
        case link = "link"
    }
}
