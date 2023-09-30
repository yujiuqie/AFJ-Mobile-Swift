//
//  PrintLog.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/16.
//

import Foundation

func printLog<T>(
    _ msg: T...,
    symbol: String = "🍺🍺🍺",
    file: String = #file,
    method: String = #function,
    line: Int = #line
) {
#if DEBUG
    let msg = msg.map { "\($0)\n" }.joined()
    let content = "\(Date()) \((file as NSString).lastPathComponent)[\(line)], \(method): \n\(msg)\n"
    Swift.print("\(symbol) \(content)")
#endif
}
