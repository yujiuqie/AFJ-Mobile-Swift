import SwiftUI

struct SampleBasicGestures: View {
  
  var body: some View {
    Form {
      Section("TapGesture") {
        Tap()
      }
      .textCase(nil)
      
      Section("SpatialTapGesture") {
        SpatialTap()
      }
      .textCase(nil)
      
      Section("LongPressGesture") {
        LongPress()
      }
      .textCase(nil)
      
      Section("DragGesture") {
        Drag()
      }
      .textCase(nil)
      
      Section("MagnificationGesture") {
        Magnification()
      }
      .textCase(nil)
      
      Section("RotationGesture") {
        Rotation()
      }
      .textCase(nil)
    }
    .formStyle(.grouped)
  }
}

fileprivate struct GradientRectangle: View {
  var size: CGFloat = 60
  
  var body: some View {
    RoundedRectangle(cornerRadius: 10)
      .fill(.blue.gradient)
      .frame(width: size, height: size)
  }
}

fileprivate struct Tap: View {
  @State private var scale1 = 1.0
  @State private var scale2 = 1.0
  @State private var locationInfo = ""
  
  var body: some View {
    LabeledContent("单击") {
      GradientRectangle()
        .scaleEffect(scale1)
        .onTapGesture {
          withAnimation {
            scale1 = scale1 == 1.0 ? 0.7 : 1.0
          }
        }
    }
    
    LabeledContent("双击") {
      GradientRectangle()
        .scaleEffect(scale2)
        .onTapGesture(count: 2) {
          withAnimation {
            scale2 = scale2 == 1.0 ? 0.7 : 1.0
          }
        }
    }
    
    LabeledContent("点击位置：\n\(locationInfo)") {
      GradientRectangle(size: 100)
        .onTapGesture(count: 1, coordinateSpace: .local) { p in
          locationInfo = p.debugDescription
        }
    }
  }
}

fileprivate struct SpatialTap: View {
  @State private var locationInfo = ""
  
  var body: some View {
    LabeledContent("点击位置：\n\(locationInfo)") {
      GradientRectangle(size: 100)
        .gesture(spatialTap)
    }
  }

  private var spatialTap: some Gesture {
    SpatialTapGesture()
      .onEnded { e in
        self.locationInfo = e.location.debugDescription
      }
  }
}

fileprivate struct LongPress: View {
  @State private var scale1 = 1.0
  @State private var scale2 = 1.0
  @State private var onPressingChanged = false
  
  var body: some View {
    LabeledContent("默认参数") {
      GradientRectangle()
        .scaleEffect(scale1)
        .onLongPressGesture {
          withAnimation {
            scale1 = scale1 == 1.0 ? 0.7 : 1.0
          }
        }
    }
    
    LabeledContent("""
    长按 1 秒
    移动距离不大于 50
    onPressingChanged: \(onPressingChanged.description)
    """) {
      GradientRectangle(size: 100)
        .scaleEffect(scale2)
        .onLongPressGesture(minimumDuration: 1, maximumDistance: 50) {
          withAnimation {
            scale2 = scale2 == 1.0 ? 0.7 : 1.0
          }
        } onPressingChanged: { changed in
          onPressingChanged = changed
        }
    }
  }
}

fileprivate struct Drag: View {
  @State private var offset = CGSize.zero
  
  var body: some View {
    GradientRectangle()
      .padding(100)
      .offset(offset)
      .gesture(drag)
  }
  
  private var drag: some Gesture {
    DragGesture()
      .onChanged { v in
        withAnimation {
          offset = v.translation
        }
      }
      .onEnded { v in
        withAnimation {
          offset = .zero
        }
      }
  }
}

fileprivate struct Magnification: View {
  @State private var scale = 1.0
  
  var body: some View {
    GradientRectangle(size: 150)
      .padding(100)
      .scaleEffect(scale)
      .gesture(
        MagnificationGesture()
          .onChanged { scale in
            withAnimation {
              self.scale = min(2.0, scale)
            }
          }
          .onEnded { _ in
            withAnimation {
              self.scale = 1.0
            }
          }
      )
  }
}

fileprivate struct Rotation: View {
  @State private var degrees = 0.0
  
  var body: some View {
    GradientRectangle(size: 200)
      .padding(100)
      .rotationEffect(.degrees(degrees))
      .gesture(
        RotationGesture()
          .onChanged { angle in
            degrees = angle.degrees
          }
          .onEnded { _ in
            degrees = 0.0
          }
      )
  }
}

struct SampleBasicGestures_Previews: PreviewProvider {
  static var previews: some View {
      SampleBasicGestures()
  }
}
