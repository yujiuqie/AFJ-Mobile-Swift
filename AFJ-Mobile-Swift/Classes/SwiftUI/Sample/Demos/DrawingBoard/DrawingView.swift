//
//  test.swift
//  DrawingBoard
//
//  Created by zzzwco on 2021/9/8.
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

struct DrawingView: View {
  @StateObject var viewModel = DrawingViewModel()
  @State private var lineColor: Color = .primary
  @State private var lineWidth: CGFloat = 5
  
  private var canvas: some View {
    Canvas { context, size in
      for v in viewModel.lines {
        context.stroke(
          v.line.path(in: .init(origin: .zero, size: size)),
          with: .color(v.color),
          style: .init(lineWidth: v.lineWidth, lineCap: .round, lineJoin: .round))
      }
    }
  }
  
  private var toolBarContent: some View {
    HStack {
      Button {
        viewModel.clear()
      } label: {
        Image(systemName: "trash")
      }
      .foregroundColor(.red)
      
      Button {
        viewModel.backward()
      } label: {
        Image(systemName: "arrow.uturn.backward.circle")
      }
      .disabled(viewModel.lines.isEmpty)
      
      Button {
        viewModel.forward()
      } label: {
        Image(systemName: "arrow.uturn.forward.circle")
      }
      .disabled(viewModel.deletedLines.isEmpty)
      
      Slider(value: $lineWidth, in: 1...10)
      Text(String(format: "%.0f", lineWidth))
      
      ColorPicker("", selection: $lineColor)
        .labelsHidden()
    }
  }
  
  var body: some View {
    canvas
    .gesture(
      DragGesture(minimumDistance: 0, coordinateSpace: .local)
        .onChanged { value in
          viewModel.addPoint(value.location, color: lineColor, width: lineWidth)
        }
        .onEnded { _ in
          viewModel.endDrawing()
        }
    )
    .toolbar {
      ToolbarItem(placement: .bottomBar) {
        toolBarContent
      }
    }
  }
}
