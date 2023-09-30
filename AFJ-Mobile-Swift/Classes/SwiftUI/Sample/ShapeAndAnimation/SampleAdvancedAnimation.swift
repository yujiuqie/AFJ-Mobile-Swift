import SwiftUI

struct SampleAdvancedAnimation: View {
  
  var body: some View {
    Form {
      Section("Transaction") {
        TransactionView()
      }
      .textCase(nil)
      
      Section("GeometryEffect") {
        GeometryEffectView()
      }
      .textCase(nil)
      
      Section {
        BuiltInTimelineView()
      } header: {
        Text("TimelineView")
      } footer: {
        Text("内置的时间调度器")
      }
      .textCase(nil)
      
      Section {
        PeriodicOffsetsView()
      } footer: {
        Text("自定义 TimelineSchedule")
      }
      
      Section {
        TimelineViewAndCanvas()
      } footer: {
        Text("TimelineView + Canvas")
      }
    }
    .formStyle(.grouped)
  }
}

fileprivate struct TransactionView: View {
  @State private var degrees = 0.0
  
  var body: some View {
    LabeledContent {
      Group {
        Rectangle()
          .fill(.red)
          .rotationEffect(.degrees(degrees))
          .animation(.default, value: degrees)
        
          Rectangle()
            .fill(.orange)
            .rotationEffect(.degrees(degrees))
            .transaction { t in
              // 在已有的 animation 基础上修改
              t.animation = t.animation?.speed(3)
            }
        
        Rectangle()
          .fill(.green)
          .rotationEffect(.degrees(degrees))
          .transaction { t in
            // 禁用动画
            t.animation = nil
          }
        
        Rectangle()
          .fill(.blue)
          .rotationEffect(.degrees(degrees))
          .transaction { t in
            // 使用新动画重写旧的
            t.animation = .interactiveSpring().delay(0.5)
          }
      }
      .frame(width: 36, height: 36)
      .padding(10)
    } label: {
      Button("rotate") {
        // 使用 withTransaction 重写动画
        var t = Transaction(animation: .linear(duration: 1))
        t.disablesAnimations = true
        
        withTransaction(t) {
          degrees += 45
        }
      }
      #if os(iOS)
      .buttonStyle(.borderless)
      #endif
    }
  }
}

fileprivate struct GeometryEffectView: View {
  @State private var progress = 0.0
  private let radius = 44.0
  
  var body: some View {
    ZStack {
      Circle()
        .stroke(.blue, lineWidth: 2)
      
      Text("🚀")
        .rotationEffect(.degrees(135 + progress * 360))
        .modifier(CircleMovingEffect(progress: progress, radius: radius))
        .animation(
          .linear(duration: 5)
          .repeatForever(autoreverses: false),
          value: progress
        )
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            progress = 1.0
          }
        }
    }
    .frame(maxWidth: .infinity, maxHeight: radius * 2)
  }
}

fileprivate struct CircleMovingEffect: GeometryEffect {
  var progress: CGFloat
  var radius: CGFloat
  
  var animatableData: CGFloat {
    get { progress }
    set { progress = newValue }
  }
  
  func effectValue(size: CGSize) -> ProjectionTransform {
    let angle = CGFloat.pi * progress * 2
    return .init(.init(
      translationX: radius * cos(angle),
      y: radius * sin(angle))
    )
  }
}

fileprivate struct BuiltInTimelineView: View {
  @State private var pause = false
  
  var body: some View {
    // 每分钟更新一次
    LabeledContent(".everyMinute") {
      TimelineView(.everyMinute) { ctx in
        text(ctx.date)
      }
    }
    
    // 根据指定时间序列更新
    LabeledContent(".explicit") {
      TimelineView(.explicit([
        Date.now.addingTimeInterval(1),
        Date.now.addingTimeInterval(2),
        Date.now.addingTimeInterval(4),
        Date.now.addingTimeInterval(8),
        Date.now.addingTimeInterval(16),
      ])) { ctx in
        text(ctx.date)
      }
    }
    
    // from: 开始更新的时间点
    // by: 更新间隔
    LabeledContent(".periodic") {
      TimelineView(.periodic(from: .now, by: 2)) { ctx in
        text(ctx.date)
      }
    }
    
    // 更新频率基本与屏幕刷新率一致
    LabeledContent(".animation") {
      TimelineView(.animation) { ctx in
        Text(formattedDate(ctx.date, format: "HH:mm:ss.SSSS"))
          .monospacedDigit()
      }
    }
    
    VStack {
      // 更新频率基本与屏幕刷新率一致
      // 支持设置最小更新间隔时间和暂停
      LabeledContent(".animation") {
        TimelineView(
          .animation(minimumInterval: 0.2, paused: pause)
        ) { ctx in
          Text(formattedDate(ctx.date, format: "HH:mm:ss.SSSS"))
            .monospacedDigit()
        }
      }
      
      Toggle("pause", isOn: $pause)
    }
  }
  
  private func text(_ date: Date) -> some View {
    Text(date.formatted(date: .omitted, time: .standard))
      .monospacedDigit()
  }
  
  private func formattedDate(_ date: Date, format: String) -> String {
    let df = DateFormatter()
    df.dateFormat = format
    return df.string(from: date)
  }
}

fileprivate struct PeriodicOffsetsView: View {
  
  var body: some View {
    LabeledContent("间隔 1/2/3 秒更新") {
      TimelineView(.periodic(offsets: [1, 2, 3])) { ctx in
        Text(ctx.date.formatted(date: .omitted, time: .standard))
          .monospacedDigit()
      }
    }
  }
}

fileprivate struct PeriodicOffsetsTimelineSchedule: TimelineSchedule {
  let offsets: [TimeInterval]
  
  func entries(from startDate: Date, mode: Mode) -> Entries {
    Entries(offsets: offsets, cur: startDate)
  }

  struct Entries: Sequence, IteratorProtocol {
    let offsets: [TimeInterval]
    var cur: Date
    var index = -1
    
    mutating func next() -> Date? {
      index = (index + 1) % offsets.count
      cur = cur.addingTimeInterval(offsets[index])
      return cur
    }
  }
}

fileprivate extension TimelineSchedule
where Self == PeriodicOffsetsTimelineSchedule {
  static func periodic(offsets: [TimeInterval]) -> Self {
    .init(offsets: offsets)
  }
}

fileprivate struct TimelineViewAndCanvas: View {
  @State private var controlYFactor = 0.0
  
  var body: some View {
    VStack {
      ZStack {
        WaveView(
          controlYFactor: controlYFactor,
          isReversed: true,
          color: .teal.opacity(0.6)
        )
        WaveView(
          controlYFactor: controlYFactor,
          color: .teal
        )
      }
      
      LabeledContent("controlYFactor: \(controlYFactor, specifier: "%.1f")") {
        Slider(value: $controlYFactor)
      }
    }
    .frame(height: 200)
  }
}

fileprivate struct WaveView: View {
  var controlYFactor: CGFloat
  var isReversed: Bool = false
  var color: Color
  
  var body: some View {
    TimelineView(.animation) { timeline in
      Canvas { ctx, size in
        var factor = timeline.date.timeIntervalSince1970
          .remainder(dividingBy: 2)
        factor = isReversed ? -factor : factor
        ctx.translateBy(x: factor * size.width, y: 0)
        ctx.fill(
          Wave(controlYFactor: controlYFactor)
            .path(in: .init(origin: .zero, size: size)),
          with: .color(color)
        )
      }
    }
  }
}

fileprivate struct Wave: Shape {
  var controlYFactor: CGFloat
  
  func path(in rect: CGRect) -> Path {
    let width = rect.width
    let height = rect.height
    let midHeight = rect.midY
    var path = Path()
    path.move(to: .init(x: 0, y: midHeight))
    path.addCurve(
      to: .init(x: width, y: midHeight),
      control1: .init(x: width * 1/3, y: height * controlYFactor),
      control2: .init(x: width * 2/3,y: height * (1 - controlYFactor))
    )
    path.addLine(to: .init(x: width, y: height))
    path.addLine(to: .init(x: 0, y: height))
    path.addLine(to: .init(x: 0, y: midHeight))
    path.addPath(path, transform: .init(translationX: rect.width, y: 0))
    path.addPath(path, transform: .init(translationX: -rect.width, y: 0))
    return path
  }
}

struct SampleAdvancedAnimation_Previews: PreviewProvider {
  static var previews: some View {
    SampleAdvancedAnimation()
  }
}
