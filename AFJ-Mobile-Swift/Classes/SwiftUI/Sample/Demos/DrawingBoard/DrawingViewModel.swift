//
//  DrawingViewModel.swift
//  DrawingBoard
//
//  Created by zzzwco on 2021/9/15.
//
//  Copyright (c) 2021 zzzwco <zzzwco@outlook.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import SwiftUI

class DrawingViewModel: ObservableObject {
  
  @Published var lines = [LineModel]()
  @Published var deletedLines = [LineModel]()
  
  func addPoint(_ point: CGPoint, color: Color, width: CGFloat) {
    if lines.isEmpty || lines.last?.isEnded == true {
      let newLine = LineModel(line: .init(points: [point]), color: color, lineWidth: width)
      lines.append(newLine)
    }
    var last = lines.removeLast()
    last.addPoint(point)
    lines.append(last)
  }
  
  func endDrawing() {
    var last = lines.removeLast()
    last.endDrawing()
    lines.append(last)
  }
  
  func backward() {
    if lines.isEmpty { return }
    let last = lines.removeLast()
    deletedLines.append(last)
  }
  
  func forward() {
    if deletedLines.isEmpty { return }
    let last = deletedLines.removeLast()
    lines.append(last)
  }
  
  func clear() {
    lines.removeAll()
    deletedLines.removeAll()
  }
}
