import SwiftUI
import Charts

struct SampleCharts: View {
  
  var body: some View {
    Form {
      Section("BasicBar") {
        BasicBar()
      }
      .textCase(nil)
      
      Section("StackedBar") {
        StackedBar()
      }
      .textCase(nil)
      
      Section("StepsChart") {
        StepsChart()
      }
      .textCase(nil)
    }
    .formStyle(.grouped)
  }
}

fileprivate struct BasicBar: View {
  @State private var barHeight: CGFloat = 150
  @State private var exchangeXY = false
  private let data: [Storage] = [
    .init(category: "Apps", sizes: 22.3),
    .init(category: "Photos", sizes: 35.8),
    .init(category: "System", sizes: 19.8),
    .init(category: "Others", sizes: 39.1),
  ]
  
  private struct Storage: Identifiable {
    let id = UUID()
    var category: String
    var sizes: Double
  }
  
  var body: some View {
    VStack {
      Chart(data, id: \.id) { v in
        if exchangeXY {
          BarMark(
            x: .value("Sizes", v.sizes),
            y: .value("Category", v.category)
          )
          .foregroundStyle(foregroundColor(item: v))
        } else {
          BarMark(
            x: .value("Category", v.category),
            y: .value("Sizes", v.sizes)
          )
        }
      }
      .frame(height: barHeight)
    
      LabeledContent("height: \(barHeight, specifier: "%.f")") {
        Slider(value: $barHeight, in: 100...300)
      }
      
      Toggle("Exchange x/y", isOn: $exchangeXY)
    }
  }
  
  private func foregroundColor(item: Storage) -> Color {
    switch item.category {
    case "Apps":
      return .red
    case "Photos":
      return .orange
    case "System":
      return .purple
    default:
      return .gray
    }
  }
}

fileprivate struct StackedBar: View {
  private let data: [Storage] = [
    .init(category: "Apps", sizes: 22.3, device: "iPhone"),
    .init(category: "Photos", sizes: 35.8, device: "iPhone"),
    .init(category: "System", sizes: 19.8, device: "iPhone"),
    .init(category: "Others", sizes: 39.1, device: "iPhone"),
    .init(category: "Apps", sizes: 18.3, device: "iPad"),
    .init(category: "Photos", sizes: 5.8, device: "iPad"),
    .init(category: "System", sizes: 22.8, device: "iPad"),
    .init(category: "Others", sizes: 12.3, device: "iPad"),
    .init(category: "Apps", sizes: 80.8, device: "Mac"),
    .init(category: "Photos", sizes: 25.6, device: "Mac"),
    .init(category: "System", sizes: 39.5, device: "Mac"),
    .init(category: "Others", sizes: 100.2, device: "Mac"),
  ]
  
  private struct Storage: Identifiable {
    let id = UUID()
    var category: String
    var sizes: Double
    var device: String
  }
  
  @State private var showLegend = true
  
  var body: some View {
    VStack {
      Chart(data, id: \.id) { v in
        BarMark(
          x: .value("Sizes", v.sizes),
          y: .value("Category", v.category)
        )
        .foregroundStyle(by: .value("Device", v.device))
      }
      .chartForegroundStyleScale([
        "iPhone" : .blue,
        "iPad" : .yellow,
        "Mac" : .purple
      ])
      .chartLegend(showLegend ? .visible : .hidden)
      
      Toggle("chartLegend", isOn: $showLegend)
    }
  }
}

fileprivate struct StepsChart: View {
  private let data: [Step] = [
    .init(date: "1/11", count: 6735),
    .init(date: "1/12", count: 9769),
    .init(date: "1/13", count: 8258),
    .init(date: "1/14", count: 12365),
    .init(date: "1/15", count: 10876),
    .init(date: "1/16", count: 7562),
    .init(date: "1/17", count: 9527),
  ]
  
  private struct Step: Identifiable, Hashable {
    let id = UUID()
    var date: String
    var count: Int
  }
  
  private var average: Int {
    data.map { $0.count }.reduce(0, +) / data.count
  }
  
  @State private var interpolationType = InterpolationType.cardinal
  @State private var showAverage = false
  @State private var showXAxis = true
  @State private var showYAxis = true
  @State private var selectedStep: (String, Int)? = ("1/15", 10876)
  
  var body: some View {
    VStack {
      Chart {
        ForEach(data, id: \.self) { v in
          LineMark(x: x(v), y: y(v))
            .foregroundStyle(.orange)
            .interpolationMethod(interpolationType.value)
          
          AreaMark(x: x(v), y: y(v))
            .foregroundStyle(
              .linearGradient(
                colors: [.orange, .orange.opacity(0.1)],
                startPoint: .top,
                endPoint: .bottom
              )
            )
            .interpolationMethod(interpolationType.value)
          
          PointMark(x: x(v), y: y(v))
            .foregroundStyle(
              v.date == "1/11" ? .red : .orange
            )
            .symbol(
              v.date == "1/11" ? .square : .circle
            )
            .annotation {
              if v.date == "1/11" {
                Image(systemName: "figure.walk")
                  .foregroundColor(.red)
              }
            }
          
          if showAverage {
            RuleMark(y: .value("Average", average))
              .annotation(alignment: .leading) {
                Text(average.formatted())
                  .font(.footnote)
              }
          }
        }
        
        if let selectedStep {
          RuleMark(x: .value("Selected Date", selectedStep.0))
            .foregroundStyle(.blue)
            .lineStyle(.init(lineWidth: 2, dash: [5, 5]))
          
          PointMark(
            x: .value("Selected Date", selectedStep.0),
            y: .value("Selected Count", selectedStep.1)
          )
          .foregroundStyle(.blue)
          .annotation {
            Text(selectedStep.1.formatted())
              .font(.footnote)
              .foregroundColor(.white)
              .padding(3)
              .background(.blue)
              .cornerRadius(5)
          }
        }
      }
      .chartXAxis(showXAxis ? .visible : .hidden)
      .chartYAxis(showYAxis ? .visible : .hidden)
      .chartOverlay { chartProxy in
        GeometryReader { geometryProxy in
          Rectangle()
            .fill(.clear)
            .contentShape(Rectangle())
            .gesture(
              DragGesture()
                .onChanged { value in
                  findSelectedStep(
                    at: value.location,
                    chartProxy: chartProxy,
                    geometryProxy: geometryProxy
                  )
                }
            )
            .onTapGesture { location in
              findSelectedStep(
                at: location,
                chartProxy: chartProxy,
                geometryProxy: geometryProxy
              )
            }
        }
      }
      
      Picker("interpolationMethod", selection: $interpolationType) {
        ForEach(InterpolationType.allCases, id: \.self) {
          Text($0.rawValue)
        }
      }
      .pickerStyle(.menu)
      
      Toggle("Average", isOn: $showAverage.animation())
      Toggle("XAxis", isOn: $showXAxis.animation())
      Toggle("YAxis", isOn: $showYAxis.animation())
    }
  }
  
  private func x(_ step: Step) -> PlottableValue<String> {
    .value("Date", step.date)
  }
  
  private func y(_ step: Step) -> PlottableValue<Int> {
    .value("Count", step.count)
  }
  
  private func findSelectedStep(
    at location: CGPoint,
    chartProxy: ChartProxy,
    geometryProxy: GeometryProxy
  ) {
    let origin = geometryProxy[chartProxy.plotAreaFrame].origin
    // 当前位置
    let location = CGPoint(
      x: location.x - origin.x,
      y: location.y - origin.y
    )
    // 获取当前位置对应的数据
    if var step: (String, Int) = chartProxy.value(at: location) {
      step.1 = data.first { $0.date == step.0 }?.count ?? 0
      selectedStep = step
    }
    printLog(selectedStep)
  }
}

fileprivate enum InterpolationType: String, CaseIterable {
  case cardinal
  case catmullRom
  case linear
  case monotone
  case stepCenter
  case stepEnd
  case stepStart
  
  var value: InterpolationMethod {
    switch self {
    case .cardinal:
      return .cardinal
    case .catmullRom:
      return .catmullRom
    case .linear:
      return .linear
    case .monotone:
      return .monotone
    case .stepCenter:
      return .stepCenter
    case .stepEnd:
      return .stepEnd
    case .stepStart:
      return .stepStart
    }
  }
}

struct SampleCharts_Previews: PreviewProvider {
  static var previews: some View {
    SampleCharts()
  }
}
