import SwiftUI

struct SampleCustomGestures: View {
  @State private var minimumVelocity: CGFloat = 150
  @State private var swipeValue: SwipeGesture.Value?
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 10)
        .fill(.blue.gradient)
        .frame(width: 260, height: 260)
        .onSwipe(minimumVelocity: minimumVelocity) { v in
          swipeValue = v
        }
        .overlay {
          Text("direction: \(swipeValue?.direction.rawValue ?? "")\n") +
          Text("velocity: \(swipeValue?.velocity ?? 0.0)")
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .safeAreaInset(edge: .bottom) {
      LabeledContent("minimumVelocity: \(minimumVelocity, specifier: "%.1f")") {
        Slider(value: $minimumVelocity, in: 50...1000)
      }
      .padding()
      .backgroundStyle(.bar)
    }
  }
}

fileprivate struct SwipeGesture: Gesture {
 
  enum Direction: String {
    case left
    case right
    case up
    case down
  }
  
  struct Value {
    var direction: Direction
    var velocity: CGFloat
  }
  
  var minimumDistance: CGFloat
  var coordinateSpace: CoordinateSpace
  
  var body: AnyGesture<Value> {
    AnyGesture(
      DragGesture(
        minimumDistance: minimumDistance,
        coordinateSpace: coordinateSpace
      )
      .map { v in
        var direction: Direction
        var velocity: CGFloat
        
        let offsetX = v.translation.width
        let offsetY = v.translation.height
        if abs(offsetX) > abs(offsetY) {
          direction = offsetX > 0 ? .right : .left
          velocity = abs(v.predictedEndTranslation.width)
        } else {
          direction = offsetY > 0 ? .down : .up
          velocity = abs(v.predictedEndTranslation.height)
        }
        return .init(direction: direction, velocity: velocity)
      }
    )
  }
}

fileprivate extension View {
  
  func onSwipe(
    minimumVelocity: CGFloat = 150,
    minimumDistance: CGFloat = 10,
    coordinateSpace: CoordinateSpace = .local,
    perform: @escaping (SwipeGesture.Value) -> Void
  ) -> some View {
    gesture(
      SwipeGesture(
        minimumDistance: minimumDistance,
        coordinateSpace: coordinateSpace
      )
      .onEnded {
        if $0.velocity >= minimumVelocity {
          perform($0)
        }
      }
    )
  }
}

struct SampleCustomGestures_Previews: PreviewProvider {
  static var previews: some View {
      SampleCustomGestures()
  }
}
