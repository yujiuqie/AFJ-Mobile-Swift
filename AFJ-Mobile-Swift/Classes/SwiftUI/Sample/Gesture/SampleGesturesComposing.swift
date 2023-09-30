import SwiftUI

struct SampleGesturesComposing: View {
  
  var body: some View {
    Form {
      Section {
        Simultaneous()
      } header: {
        Text("Simultaneous")
      } footer: {
        Text("旋转 + 缩放")
      }
      .textCase(nil)
      
      Section {
        Sequence()
      } header: {
        Text("Sequence")
      } footer: {
        Text("长按之后才能拖拽")
      }
      .textCase(nil)
      
      Section {
        Exclusive()
      } header: {
        Text("Exclusive")
      } footer: {
        Text("单击/缩放")
      }
      .textCase(nil)
    }
    .formStyle(.grouped)
  }
}


fileprivate struct Simultaneous: View {
  @State private var scale = 1.0
  @State private var degrees = 0.0
  
  var body: some View {
    RoundedRectangleView(
      degrees: degrees,
      scale: scale
    )
    .gesture(
      RotationGesture()
        .onChanged { angle in
          self.degrees = angle.degrees
        }
        .onEnded { _ in
          self.degrees = 0.0
        }
        .simultaneously(
          with: MagnificationGesture()
            .onChanged { scale in
              self.scale = scale
            }
            .onEnded { _ in
              self.scale = 1.0
            }
        )
    )
  }
}

fileprivate struct Sequence: View {
  @State private var offset = CGSize.zero
  @State private var fillColor: Color = .blue
  
  var body: some View {
    RoundedRectangleView(
      size: 60,
      fillColor: fillColor,
      offset: offset
    )
    .gesture(
      LongPressGesture(minimumDuration: 1)
        .onEnded { _ in
          fillColor = .green
        }
        .sequenced(
          before: DragGesture()
            .onChanged { v in
              offset = v.translation
            }
            .onEnded { _ in
              offset = .zero
              fillColor = .blue
            }
        )
    )
  }
}

fileprivate struct Exclusive: View {
  @State private var fillColor = Color.blue
  @State private var scale = 1.0
  
  var body: some View {
    RoundedRectangleView(
      fillColor: fillColor,
      scale: scale
    )
    .gesture(
      TapGesture()
        .onEnded {
          fillColor = fillColor == .blue ? .green : .blue
        }
        .exclusively(
          before: MagnificationGesture()
            .onChanged { scale in
              self.scale = scale
            }
            .onEnded { _ in
              self.scale = 1.0
            }
        )
    )
  }
}


fileprivate struct RoundedRectangleView: View {
  var size: CGFloat = 120
  var fillColor: Color = .blue
  var offset: CGSize = .zero
  var degrees: Double = 0.0
  var scale: CGFloat = 1.0
  
  var body: some View {
    RoundedRectangle(cornerRadius: 12)
      .fill(fillColor.gradient)
      .frame(width: size, height: size)
      .offset(offset)
      .rotationEffect(.degrees(degrees))
      .scaleEffect(scale)
      .padding(size)
  }
}

struct SampleGesturesComposing_Previews: PreviewProvider {
  static var previews: some View {
      SampleGesturesComposing()
  }
}
