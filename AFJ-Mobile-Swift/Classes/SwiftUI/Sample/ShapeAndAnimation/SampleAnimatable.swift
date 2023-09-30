import SwiftUI

struct SampleAnimatable: View {
  
  @State private var l1_controlYFactor = 0.0
  
  @State private var l2_controlYFactor = 0.5
  @State private var l2_pointYFactor = 0.5
  
  @State private var l3_data = LineData(
    controYFactor: 0.0,
    pointYFactor: 0.5,
    pointXFactor: 0.0
  )
  
  var body: some View {
    Form {
      Group {
        Line1(controYFactor: l1_controlYFactor)
          .stroke(.blue, style: strokeStyle)
        
        Line2(
          controYFactor: l2_controlYFactor,
          pointYFactor: l2_pointYFactor
        )
        .stroke(.blue, style: strokeStyle)
        
        Line3(lineData: l3_data)
        .stroke(.blue, style: strokeStyle)
      }
      .frame(height: 150)
      .padding(.vertical, 30)
      
      Button("Update") {
        withAnimation(
          .spring(response: 0.3, dampingFraction: 0.3)
        ) {
          l1_controlYFactor = .random(in: 0...2)
          
          l2_controlYFactor = .random(in: 0...2)
          l2_pointYFactor = .random(in: 0.2...0.8)
       
          l3_data = .init(
            controYFactor: .random(in: 0...2),
            pointYFactor: .random(in: 0.2...0.8),
            pointXFactor: .random(in: 0...0.4)
          )
        }
      }
      .frame(maxWidth: .infinity)
      #if os(iOS)
      .buttonStyle(.borderless)
      #endif
    }
    .formStyle(.grouped)
  }
  
  private var strokeStyle: StrokeStyle {
    .init(lineWidth: 5, lineCap: .round, lineJoin: .round)
  }
}

fileprivate struct Line1: Shape {
  var controYFactor: Double = 0
  
  var animatableData: Double {
    get { controYFactor }
    set { controYFactor = newValue }
  }
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: .init(x: 0, y: rect.midY))
    path.addQuadCurve(
      to: .init(x: rect.maxX, y: rect.midY),
      control: .init(x: rect.midX, y: rect.midY * controYFactor)
    )
    return path
  }
}

fileprivate struct Line2: Shape {
  var controYFactor = 0.0
  var pointYFactor = 0.0
  
  var animatableData: AnimatablePair<Double, Double> {
    get {
      .init(controYFactor, pointYFactor)
    }
    set {
      controYFactor = newValue.first
      pointYFactor = newValue.second
    }
  }
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: .init(x: 0, y: rect.maxY * pointYFactor))
    path.addQuadCurve(
      to: .init(x: rect.maxX, y: rect.maxY * pointYFactor),
      control: .init(x: rect.midX, y: rect.midY * controYFactor)
    )
    return path
  }
}

fileprivate struct Line3: Shape {
  var lineData: LineData
  
  var animatableData: LineData {
    get { lineData }
    set { lineData = newValue }
  }
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: .init(
      x: rect.maxX * lineData.pointXFactor,
      y: rect.maxY * lineData.pointYFactor)
    )
    path.addQuadCurve(
      to: .init(
        x: rect.maxX * (1 - lineData.pointXFactor),
        y: rect.maxY * lineData.pointYFactor
      ),
      control: .init(
        x: rect.midX,
        y: rect.midY * lineData.controYFactor
      )
    )
    return path
  }
}

struct LineData: VectorArithmetic {
  var controYFactor: Double
  var pointYFactor: Double
  var pointXFactor: Double
  
  static func + (lhs: Self, rhs: Self) -> Self {
    .init(
      controYFactor: lhs.controYFactor + rhs.controYFactor,
      pointYFactor: lhs.pointYFactor + rhs.pointYFactor,
      pointXFactor: lhs.pointXFactor + rhs.pointXFactor
    )
  }
  
  static func - (lhs: Self, rhs: Self) -> Self {
    .init(
      controYFactor: lhs.controYFactor - rhs.controYFactor,
      pointYFactor: lhs.pointYFactor - rhs.pointYFactor,
      pointXFactor: lhs.pointXFactor - rhs.pointXFactor
    )
  }
  
  static var zero: LineData {
    .init(controYFactor: 0, pointYFactor: 0, pointXFactor: 0)
  }
  
  var magnitudeSquared: Double {
    1.0
  }
  
  mutating func scale(by rhs: Double) {
    controYFactor.scale(by: rhs)
    pointYFactor.scale(by: rhs)
    pointXFactor.scale(by: rhs)
  }
}

struct SampleAnimatable_Previews: PreviewProvider {
  static var previews: some View {
    SampleAnimatable()
  }
}
