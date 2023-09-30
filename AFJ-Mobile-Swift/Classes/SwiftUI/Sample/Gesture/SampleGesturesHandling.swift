import SwiftUI

struct SampleGesturesHandling: View {
  @State private var isPresented = false
  
  var body: some View {
    Form {
      Section("限定点击范围") {
        ContentShape()
      }
      .textCase(nil)
      
      Section("Priority") {
        Priority()
      }
      .textCase(nil)
      
      Section("GestureMask") {
        GestureMaskView()
      }
      .textCase(nil)
      
      Section("屏幕边缘手势处理") {
        #if os(iOS)
//        NavigationLink(".defersSystemGestures") {
//          DefersSystemGestures()
//        }
        Button(".defersSystemGestures") {
          isPresented.toggle()
        }
        .fullScreenCover(isPresented: $isPresented) {
          DefersSystemGestures()
        }
        #else
        Text("请在 iOS 上查看")
        #endif
      }
    }
    .formStyle(.grouped)
  }
}

fileprivate struct ContentShape: View {
  @State private var tapped = false
  
  var body: some View {
    Rectangle()
      .fill(tapped ? .red : .blue)
      .frame(height: 200)
      .contentShape(Triangle())
      .onTapGesture {
        tapped.toggle()
      }
      // 辅助线
      .overlay {
        Triangle()
          .stroke(.secondary)
      }
  }
}

fileprivate struct Triangle: Shape {
  
  func path(in rect: CGRect) -> Path {
    Path { path in
      path.move(to: CGPoint(x: rect.midX, y: 0))
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
      path.addLine(to: CGPoint(x: 0, y: rect.maxY))
      path.closeSubpath()
    }
  }
}

fileprivate struct Priority: View {
  @State private var tappedColor: Color?
  
  var body: some View {
    VStack {
      ZStack {
        Rectangle()
          .fill(.blue)
        
        orangeRectangle
      }
      .frame(height: 200)
      //.onTapGesture {
      //  tappedColor = .blue
      //}
      .highPriorityGesture(
        TapGesture()
          .onEnded {
            tappedColor = .blue
          }
      )
      
      Text("点击区域：\(tappedColor?.description ?? "")")
        .font(.footnote)
        .foregroundColor(tappedColor)
    }
  }
  
  private var orangeRectangle: some View {
    Rectangle()
      .fill(.orange)
      .padding(50)
      .onTapGesture {
        tappedColor = .orange
      }
  }
}

fileprivate struct GestureMaskView: View {
  
  var body: some View {
    LabeledContent(".all") {
      ConcentricCircles(gestureMask: .all)
    }
    
    LabeledContent(".gesture") {
      ConcentricCircles(gestureMask: .gesture)
    }
    
    LabeledContent(".subviews") {
      ConcentricCircles(gestureMask: .subviews)
    }
    
    LabeledContent(".none") {
      ConcentricCircles(gestureMask: .none)
    }
  }
}

fileprivate struct ConcentricCircles: View {
  var gestureMask: GestureMask
  @State private var innerScale = 0.7
  @State private var outerScale = 0.7
  
  var body: some View {
    ZStack {
      Circle()
        .fill(.blue)
        .frame(height: 200)
        .scaleEffect(outerScale)
      
      Circle()
        .fill(.background)
        .frame(height: 100)
        .scaleEffect(innerScale)
        .highPriorityGesture(innerTap)
    }
    .gesture(outerTap, including: gestureMask)
  }
  
  private var outerTap: some Gesture {
    TapGesture()
      .onEnded { _ in
        withAnimation {
          outerScale = outerScale == 1.0 ? 0.7 : 1.0
        }
      }
  }
  
  private var innerTap: some Gesture {
    TapGesture()
      .onEnded { _ in
        withAnimation {
          innerScale = innerScale == 1.0 ? 0.7 : 1.0
        }
      }
  }
}

#if os(iOS)
fileprivate struct DefersSystemGestures: View {
  @State private var locationInfo = ""
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    VStack {
      Text(locationInfo)
        .frame(maxHeight: .infinity)
      
      HStack {
        Spacer()
        Button("Done") {
          dismiss()
        }
      }
      .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .contentShape(Rectangle())
    .gesture(
      DragGesture()
        .onChanged { value in
          locationInfo = value.location.debugDescription
        }
    )
    .defersSystemGestures(on: .all)
  }
}
#endif

struct SampleGesturesHandling_Previews: PreviewProvider {
  static var previews: some View {
      SampleGesturesHandling()
  }
}
