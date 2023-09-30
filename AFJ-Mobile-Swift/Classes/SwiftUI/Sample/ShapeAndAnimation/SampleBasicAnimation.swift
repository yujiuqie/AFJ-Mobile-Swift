import SwiftUI

struct SampleBasicAnimation: View {
  @State private var offsetX: CGFloat = 0
  
  var body: some View {
    Form {
      Section("animation Modifier") {
        AnimationModifier()
      }
      .textCase(nil)
      
      Section("withAnimation Function") {
        WithAnimationFunction()
      }
      .textCase(nil)
      
      Section("Built-in Animation") {
        BuiltInAnimation()
      }
      .textCase(nil)
      
      Section {
        SpringAnimation()
      }
      
      Section("Binding Animation") {
        BindingAnimation()
      }
      .textCase(nil)
      
    }
    .formStyle(.grouped)
    .onAppear {
      offsetX = 200
    }
  }
}

fileprivate struct AnimationModifier: View {
  @State private var to: CGFloat = 0
  @State private var rotation: CGFloat = 0
  
  var body: some View {
    // Form、List 中无法正确执行动画，诡异。。。
    // 使用 ZStack 或 VStack 之类的容器包一层就正常了
    ZStack {
      Circle()
        .trim(from: 0, to: to)
        .stroke(style: .init(lineWidth: 5, lineCap: .round))
        .foregroundColor(.blue)
        .frame(width: 40, height: 40)
        .rotationEffect(.degrees(rotation))
        .animation(
          .linear(duration: 3)
          .repeatForever(autoreverses: false),
          value: rotation
        )
        .animation(
          .linear(duration: 3)
          .repeatForever(autoreverses: false),
          value: to
        )
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            to = 1.0
            rotation = 360
          }
        }
    }
  }
}

fileprivate struct WithAnimationFunction: View {
  @State private var to: CGFloat = 0.1
  @State private var rotation: CGFloat = 0
  
  var body: some View {
    VStack(alignment: .leading) {
      Circle()
        .trim(from: 0, to: to)
        .stroke(style: .init(lineWidth: 5, lineCap: .round))
        .foregroundColor(.blue)
        .frame(width: 40, height: 40)
        .rotationEffect(.degrees(rotation))
      
      Button("Perform") {
        withAnimation(
          .linear(duration: 3)
          .repeatForever(autoreverses: false)
        ) {
          to = 1.0
          rotation = 360
        }
      }
      #if os(iOS)
      .buttonStyle(.borderless)
      #endif
    }
  }
}

fileprivate struct BuiltInAnimation: View {
  private let duration = 5.0
  
  var body: some View {
    GradientCircle(
      title: ".default",
      animation: .default
        // 动画执行速度
        .speed(0.08)
        // 延迟执行
        .delay(2)
        .repeatForever(autoreverses: false)
    )
    
    GradientCircle(
      title: ".linear",
      animation: .linear(duration: duration)
        .delay(0.3)
        .repeatForever(autoreverses: false)
    )
    
    GradientCircle(
      title: ".easeIn",
      animation: .easeIn(duration: duration)
        .delay(0.3)
        .repeatForever(autoreverses: false)
    )
    
    GradientCircle(
      title: ".easeOut",
      animation: .easeOut(duration: duration)
        .delay(0.3)
        .repeatForever(autoreverses: false)
    )
    
    GradientCircle(
      title: ".easeInOut",
      animation: .easeInOut(duration: duration)
        .delay(0.3)
        .repeatForever(autoreverses: false)
    )
  }
}

fileprivate struct SpringAnimation: View {
  @State private var response = 0.3
  @State private var dampingFraction = 0.3
  
  @State private var offsetX1 = 0.0
  @State private var offsetX2 = 0.0
  
  @State private var mass = 0.1
  @State private var stiffness = 100.0
  @State private var damping = 0.5
  @State private var initialVelocity = 0.0
  
  var body: some View {
    circle1
    circle2
  }
  
  private var circle1: some View {
    VStack(alignment: .leading) {
      circle.offset(x: offsetX1)
      LabeledContent("response: \(response, specifier: "%.1f")") {
        Slider(value: $response, in: 0.1...2)
      }
      LabeledContent("dampingFraction:\n\(dampingFraction, specifier: "%.1f")") {
        Slider(value: $dampingFraction, in: 0.1...1)
      }
      HStack {
        Button("Reset") {
          offsetX1 = 0
        }
        Spacer()
        Button("Perform") {
          withAnimation(
            .spring(response: response, dampingFraction: dampingFraction)
          ) {
            offsetX1 = 150
          }
        }
      }
      #if os(iOS)
      .buttonStyle(.borderless)
      #endif
    }
  }
  
  private var circle2: some View {
    VStack(alignment: .leading) {
      circle.offset(x: offsetX2)
      LabeledContent("mass: \(mass, specifier: "%.1f")") {
        Slider(value: $mass, in: 0.1...2)
      }
      LabeledContent("stiffness: \(stiffness, specifier: "%.1f")") {
        Slider(value: $stiffness, in: 0.1...100)
      }
      LabeledContent("damping: \(damping, specifier: "%.1f")") {
        Slider(value: $damping, in: 0.1...2)
      }
      LabeledContent("initialVelocity: \(initialVelocity, specifier: "%.1f")") {
        Slider(value: $initialVelocity, in: -10...10)
      }
      HStack {
        Button("Reset") {
          offsetX2 = 0
        }
        Spacer()
        Button("Perform") {
          withAnimation(
            .interpolatingSpring(
              mass: mass,
              stiffness: stiffness,
              damping: damping,
              initialVelocity: initialVelocity
            )
          ) {
            offsetX2 = 150
          }
        }
      }
      #if os(iOS)
      .buttonStyle(.borderless)
      #endif
    }
  }
  
  private var circle: some View {
    Circle()
      .fill(.blue.gradient)
      .frame(width: 44, height: 44)
  }
}

fileprivate struct GradientCircle: View {
  let title: String
  let animation: Animation
  
  @State private var offsetX = 0.0
  @State private var degrees = 0.0
  @State private var opacity = 0.1
  
  var body: some View {
    LabeledContent(title) {
      Circle()
        .fill(
          .linearGradient(
            colors: [.yellow, .orange, .red, .black],
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .frame(width: 44, height: 44)
        .rotationEffect(.degrees(degrees))
        .offset(x: offsetX)
        .opacity(opacity)
        .shadow(radius: 10)
        .onAppear {
          withAnimation(animation) {
            offsetX = -150
            degrees = 360
            opacity = 1.0
          }
        }
    }
  }
}

fileprivate struct BindingAnimation: View {
  private let count = 6
  @State private var blooming = false
  
  var body: some View {
    VStack {
      ZStack {
        ForEach(0..<count, id: \.self) { i in
          Ellipse()
            .fill(.pink.gradient)
            .frame(width: width, height: height)
            .offset(x: width / 2)
            .rotationEffect(
              .degrees(Double(i * 360 / count))
            )
        }
      }
      .frame(height: 150)
      .rotationEffect(
        .degrees(blooming ? 60 : 0)
      )
      
      Toggle(
        "blooming",
        isOn: $blooming
          .animation(
            .spring(response: 0.3, dampingFraction: 0.3)
          )
      )
    }
  }
  
  private var width: CGFloat {
    blooming ? 60 : 15
  }
  
  private var height: CGFloat {
    blooming ? 45 : 5
  }
}

struct SampleBasicAnimation_Previews: PreviewProvider {
  static var previews: some View {
    SampleBasicAnimation()
  }
}
