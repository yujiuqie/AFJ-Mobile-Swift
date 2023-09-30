import SwiftUI

struct SampleDrawing: View {
  
  var body: some View {
    Form {
      Section("Canvas") {
        BasicCanvas()
      }
      .textCase(nil)
      
      Section("More Gradient") {
        MoreGradient()
      }
      .textCase(nil)
      
      Section("View Transforming") {
        ViewTransforming()
      }
      .textCase(nil)
      
      Section("Mask") {
        Mask()
      }
      .textCase(nil)
      
      Section("Compositing Views") {
        CompositingViews()
      }
      .textCase(nil)
    }
    .formStyle(.grouped)
  }
}

fileprivate struct BasicCanvas: View {
  
  var body: some View {
    Canvas { context, size in
      // 绘制图片
      context.draw(
        Image(systemName: "sun.max.fill")
          .symbolRenderingMode(.multicolor),
        at: .init(x: size.width * 0.1, y: size.height * 0.1)
      )
      
      // 使用上下文副本绘制渐变色椭圆
      // 这里我们将 context 赋值给 ct1，然后在 ct1 上绘制渐变色的椭圆。
      // 为什么要这样操作呢？
      // 因为我们在绘制渐变椭圆时，需要使用蒙版对绘图区域做裁剪，
      // 如果直接在 context 上操作，会改变 context 的绘制区域，这会影响到后面的绘制操作。
      // 而 `var ct1 = context` 这行代码的作用就是在透明的图层树中创建了一个 context 的副本 ct1，我们在副本 ct1 中进行各种绘制、裁剪、变换等操作，不会污染到主上下文 context。
      var ct1 = context
      // 为整个画布设置蒙版区域，这里表示左半区域
      let maskedSize = size.applying(CGAffineTransform(scaleX: 0.5, y: 1))
      // 使用蒙版裁剪绘制区域
      ct1.clip(to: Path(CGRect(origin: .zero, size: maskedSize)))
      // 填充
      ct1.fill(
        Path(ellipseIn: CGRect(origin: .zero, size: size)
          .insetBy(dx: 10, dy: 10)),
        with: .linearGradient(
          .init(colors: [.red, .orange, .yellow, .green, .cyan, .blue, .purple]),
          startPoint: .zero,
          endPoint: .init(x: 0, y: size.height)))
      
      // 回到主上下文绘制 Hello
      // 如果上面的绘制不是在副本 ct1 上操作
      // 这里的文本时无法完整展示的，后面的绘制都会收到影响
      context.draw(
        Text("Hello").bold(),
        at: .init(x: size.width * 0.5, y: size.height * 0.25)
      )
      
      // 使用 drawLayer 生成上下文副本
      // 这里我们使用 `drawLayer` 来进行绘制，它的闭包内返回的实际上就是 context 的副本，这也是一种使用副本操作的实现方式，和上面的方法（var ct1 = context）异曲同工。
      context.drawLayer { ct in
        // 闭包返回的是一个新的上下文副本
        // 不会影响到主上下文，效果和上面绘制渐变色椭圆一样
        // 裁剪绘图上下文
        ct.clip(to: Path(
          roundedRect: .init(
            x: size.width * 0.5,
            y: 0,
            width: size.width * 0.5,
            height: size.height),
          cornerRadius: 50))
        // 绘图上下文偏移
        ct.transform = CGAffineTransform(translationX: 50, y: 50)
        // 填充上下文
        // 本来是矩形，因为裁剪和偏移效果，所以呈现`示例`中的效果
        ct.fill(Path(roundedRect: .init(
          x: size.width * 0.5,
          y: 0,
          width: size.width * 0.5,
          height: size.height),
                     cornerRadius: 0),
                with: .color(.cyan))
      }
      
      // 回到主上下文继续绘制
      context.draw(
        Text("Wolrd").bold(),
        at: .init(x: size.width * 0.5, y: size.height * 0.75)
      )
    }
    // 画布大小，闭包返回的 size 就是这个值
    .frame(width: 300, height: 200)
    // 画布边框
    .overlay(
      RoundedRectangle(
        cornerRadius: 16,
        style: .continuous
      )
      .stroke(.blue, style: .init(lineWidth: 1))
    )
  }
}

fileprivate struct MoreGradient: View {
  @State private var colors: [Color] = [.red, .green, .blue]
  var body: some View {
    GroupBox("Angular") {
      Circle()
        .fill(
          .angularGradient(
            colors: colors,
            center: .center,
            startAngle: .degrees(0),
            endAngle: .degrees(360)
          )
        )
        .frame(height: 150)
    }
    
    GroupBox("Radial") {
      Circle()
        .fill(
          .radialGradient(
            colors: colors,
            center: .center,
            startRadius: 0,
            endRadius: 50
          )
        )
        .frame(height: 150)
    }
  }
}

fileprivate struct ViewTransforming: View {
  @State private var degrees: Double = 45
  @State private var x = false
  @State private var y = true
  @State private var z = false
  
  var body: some View {
    GroupBox("rotationEffect") {
      Text("Hello World")
        .frame(height: 100)
        .rotationEffect(.degrees(degrees), anchor: .center)
    }
    
    GroupBox("rotationEffect") {
      Text("Hello World")
        .frame(height: 100)
        .rotation3DEffect(
          .degrees(degrees),
          axis: (x ? 1 : 0, y ? 1 : 0, z ? 1 : 0)
        )
      
      Toggle("x", isOn: $x)
      Toggle("y", isOn: $y)
      Toggle("z", isOn: $z)
    }
    
    LabeledContent("degrees: \(degrees, specifier: "%.1f")") {
      Slider(value: $degrees, in: 0...360)
    }
  }
}

fileprivate struct Mask: View {
  @State private var mask = true
  
  var body: some View {
    GroupBox("mask") {
      if mask {
        image
          .mask {
            Text("zzzwco")
              .font(.system(size: 60, weight: .bold))
          }
      } else {
        image
      }
      
      Toggle("mask", isOn: $mask)
    }
  }
  
  private var image: some View {
    Image("parrot")
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 260)
  }
}

fileprivate struct CompositingViews: View {
  
  var body: some View {
    GroupBox("blendMode") {
      BlendeModeView()
    }
    
    GroupBox("compositingGroup") {
      CompositingGroupView()
    }
    
    GroupBox("drawingGroup") {
      DrawingGroupView()
    }
  }
}

fileprivate struct BlendeModeView: View {
  @State private var blendMode = BlendMode.multiply
  
  var body: some View {
    ZStack {
      Circle()
        .fill(.red)
        .frame(height: 120)
        .offset(y: -50)
      
      Circle()
        .fill(.green)
        .frame(height: 120)
        .offset(x: -40)
      
      Circle()
        .fill(.blue)
        .frame(height: 120)
        .offset(x: 40)
    }
    .frame(height: 200)
    .blendMode(blendMode)
    
    LabeledContent("blendMode") {
      Picker("", selection: $blendMode) {
        ForEach(BlendMode.allCases, id: \.self) {
          Text($0.description)
        }
      }
    }
  }
}

fileprivate struct CompositingGroupView: View {
  @State private var compositingGroup = false
  
  var body: some View {
    if compositingGroup {
      compositingGroupView
        .compositingGroup()
        .shadow(color: .red, radius: 3)
    } else {
      compositingGroupView
        .shadow(color: .red, radius: 3)
    }
    Toggle("compositingGroup", isOn: $compositingGroup)
  }
  
  private var compositingGroupView: some View {
    ZStack {
      Capsule()
        .fill(.yellow)
        .frame(width: 150, height: 60)
      Text("Hello")
        .font(.largeTitle)
        .bold()
    }
  }
}

fileprivate struct DrawingGroupView: View {
  @State private var blooming = false
  @State private var drawingGroup = false
  private let count = 1000
  
  var body: some View {
    VStack {
      if drawingGroup {
        flower.drawingGroup()
      } else {
        flower
      }
      
      Toggle("blooming", isOn: $blooming.animation())
      Toggle("drawingGroup", isOn: $drawingGroup)
    }
  }
  
  private var flower: some View {
    var widths = [CGFloat]()
    var heights = [CGFloat]()
    for _ in 0..<count {
      widths.append(.random(in: 0...(blooming ? 80 : 30)))
      heights.append(.random(in: 5...20))
    }
    return ZStack {
      ForEach(0..<count, id: \.self) { i in
        Ellipse()
          .fill(
            [
              Color.red.gradient,
              Color.orange.gradient,
              Color.yellow.gradient,
              Color.green.gradient,
              Color.indigo.gradient,
              Color.blue.gradient,
              Color.purple.gradient,
            ].randomElement()!
          )
          .frame(
            width: widths[i],
            height: blooming ? heights[i] : 2
          )
          .offset(x: widths[i] * 0.5)
          .rotationEffect(.degrees(.random(in: 0...360)))
      }
    }
    .frame(width: 200, height: 200)
  }
}

extension BlendMode: CustomStringConvertible, CaseIterable {
  public static var allCases: [BlendMode] = [
    .normal,
    .multiply,
    .hardLight,
    .difference,
    .exclusion,
    .luminosity
  ]
  
  public var description: String {
    switch self {
    case .normal:
      return ".normal"
    case .multiply:
      return ".multiply"
    case .hardLight:
      return ".hardLight"
    case .difference:
      return ".difference"
    case .exclusion:
      return ".exclusion"
    case .luminosity:
      return ".luminosity"
    case .screen:
        return ".screen"
    case .overlay:
        return ".overlay"
    case .darken:
        return ".darken"
    case .lighten:
        return ".lighten"
    case .colorDodge:
        return ".colorDodge"
    case .colorBurn:
        return ".colorBurn"
    case .softLight:
        return ".softLight"
    case .hue:
        return ".hue"
    case .saturation:
        return ".saturation"
    case .color:
        return ".color"
    case .sourceAtop:
        return ".sourceAtop"
    case .destinationOver:
        return ".destinationOver"
    case .destinationOut:
        return ".destinationOut"
    case .plusDarker:
        return ".plusDarker"
    case .plusLighter:
        return ".plusLighter"
    @unknown default:
      return "unknown"
    }
  }
}

struct SampleDrawing_Previews: PreviewProvider {
  static var previews: some View {
    SampleDrawing()
  }
}
