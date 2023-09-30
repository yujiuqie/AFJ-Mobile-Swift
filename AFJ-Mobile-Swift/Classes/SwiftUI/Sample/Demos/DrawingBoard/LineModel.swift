//
//  LineModel.swift
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

struct LineModel {
  
  var line: Line
  var color: Color
  var lineWidth: CGFloat
  var isEnded: Bool = false
  
  mutating func addPoint(_ point: CGPoint) {
    line.points.append(point)
  }
  
  mutating func endDrawing() {
    isEnded = true
  }
  
  struct Line: Shape {
    
    var points: [CGPoint] = []
    
    func path(in rect: CGRect) -> Path {
      var path = Path()
      path.move(to: points[0])
      for i in 1..<points.count {
        path.addLine(to: points[i])
      }
      return path
    }
  }
}
