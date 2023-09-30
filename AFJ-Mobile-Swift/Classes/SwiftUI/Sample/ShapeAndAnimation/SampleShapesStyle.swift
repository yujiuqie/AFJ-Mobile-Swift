import SwiftUI

struct SampleShapesStyle: View {
  
  var body: some View {
    Form {
      Section("Fill") {
        FillView()
      }
      .textCase(nil)
      
      Section("Stroke") {
        StrokeView()
      }
      .textCase(nil)
      
      Section("containerShape") {
        ContainerShapeView()
      }
      .textCase(nil)
      
      Section("clipShape") {
        ClipShapeView()
      }
      .textCase(nil)
      
      Section("trim") {
        TrimView()
      }
      .textCase(nil)
    }
    .formStyle(.grouped)
  }
}

fileprivate struct FillView: View {
  
  var body: some View {
    HStack {
      Circle()
        .fill(.blue)
      Circle()
        .fill(.blue.gradient)
      Circle()
        .fill(
          .linearGradient(
            colors: [.blue, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
        )
    }
    .frame(height: 100)
  }
}

fileprivate struct StrokeView: View {
  private let linearGradient: LinearGradient =
    .linearGradient(
      colors: [.yellow, .orange, .red],
      startPoint: .top,
      endPoint: .bottom)
  
  var body: some View {
    HStack {
      Circle()
        .stroke(
          linearGradient,
          style: .init(
            lineWidth: 10,
            lineCap: .round,
            lineJoin: .round,
            dash: [5, 15]
          )
        )
        .frame(height: 100)
        .background(
          Circle()
            .fill(.blue)
        )
      
      Circle()
        .fill(.blue)
        .frame(height: 100)
        .overlay(
          Circle()
            .strokeBorder(linearGradient, lineWidth: 10)
        )
    }
  }
}

fileprivate struct ContainerShapeView: View {
  
  var body: some View {
    ZStack {
      Text("Hello World")
        .padding(90)
        .background(.purple)
      
      Text("Hello World")
        .padding(60)
        .background(.indigo)
      
      Text("Hello World")
        .padding(30)
        .background(.blue)
    }
    .containerShape(
      RoundedRectangle(cornerRadius: 70)
    )
  }
}

fileprivate struct ClipShapeView: View {
  
  var body: some View {
    Text("Hello World")
      .padding()
      .background(.orange)
      .clipShape(Capsule())
  }
}

fileprivate struct TrimView: View {
  @State private var from: CGFloat = 0
  @State private var to: CGFloat = 0.1
  
  var body: some View {
    HStack(spacing: 20) {
      Circle()
        .trim(from: from, to: to)
        .stroke(
          .blue.gradient,
          style: .init(lineWidth: 10, lineCap: .round)
        )
        .frame(height: 100)
      
      Rectangle()
        .trim(from: from, to: to)
        .stroke(
          .blue.gradient,
          style: .init(lineWidth: 10)
        )
        .frame(width: 100, height: 50)
    }
    LabeledContent("to: \(to, specifier: "%.1f")") {
      Slider(value: $to)
    }
  }
}

struct SampleShapesStyle_Previews: PreviewProvider {
  static var previews: some View {
    SampleShapesStyle()
  }
}
