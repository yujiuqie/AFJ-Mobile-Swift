import SwiftUI

struct SamplePath: View {
  @State private var eoFill = true
  
  var body: some View {
    Form {
      Section("Triangle") {
        Triangle()
          .fill(.blue.gradient)
          .frame(width: 100, height: 100)
      }
      .textCase(nil)
      
      
      Section("StrangeShape") {
        ThreeCircles()
          .fill(.blue.gradient, style: .init(eoFill: eoFill))
          .frame(height: 150)
        Toggle("eoFill", isOn: $eoFill)
      }
      .textCase(nil)
      
      Section("Taiji") {
        TaijiView()
      }
      .textCase(nil)
    }
    .formStyle(.grouped)
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

fileprivate struct ThreeCircles: Shape {
  
  func path(in rect: CGRect) -> Path {
    let radius = rect.height / 3
    var path = Path()
    path.addArc(
      center: .init(x: rect.midX, y: radius),
      radius: radius,
      startAngle: .degrees(0),
      endAngle: .degrees(360),
      clockwise: true
    )
    path.addArc(
      center: .init(x: rect.midX - radius * 0.67, y: radius * 2),
      radius: radius,
      startAngle: .degrees(0),
      endAngle: .degrees(360),
      clockwise: true
    )
    path.addArc(
      center: .init(x: rect.midX + radius * 0.67, y: radius * 2),
      radius: radius,
      startAngle: .degrees(0),
      endAngle: .degrees(360),
      clockwise: true
    )
    return path
  }
}

fileprivate struct HalfTaiji: Shape {
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    let outRadius = rect.height * 0.5
    let innerRadius = rect.height * 0.25
      
    path.move(to: CGPoint(x: rect.midX, y: 0))
    path.addArc(
      center: CGPoint(x: rect.midX, y: rect.midY),
      radius: outRadius,
      startAngle: Angle(degrees: -90),
      endAngle: Angle(degrees: -270),
      clockwise: true
    )
    path.addArc(
      center: CGPoint(x: rect.midX, y: rect.height * 0.75),
      radius: innerRadius,
      startAngle: Angle(degrees: 90),
      endAngle: Angle(degrees: 270),
      clockwise: false
    )
    path.addArc(
      center: CGPoint(x: rect.midX, y: rect.height * 0.25),
      radius: innerRadius,
      startAngle: Angle(degrees: -270),
      endAngle: Angle(degrees: -90),
      clockwise: true
    )
    return path
  }
}

fileprivate struct TaijiView: View {
  
  var body: some View {
    ZStack {
      halfTaijiView(isWhite: true)
      halfTaijiView(isWhite: false)
    }
    .frame(width: 200, height: 200)
    .shadow(radius: 10)
  }
  
  private func halfTaijiView(isWhite: Bool) -> some View {
    HalfTaiji()
      .rotation(Angle(degrees: isWhite ? 0 : 180))
      .fill(isWhite ? .white : .black)
      .overlay(
        Circle()
          .fill(isWhite ? .black : .white)
          .frame(width: 20, height: 20)
          .offset(x: 0, y: isWhite ? -50 : 50)
      )
  }
}

struct SamplePath_Previews: PreviewProvider {
  static var previews: some View {
    SamplePath()
  }
}
