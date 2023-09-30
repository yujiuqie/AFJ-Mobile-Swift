import SwiftUI

struct SampleTransitions: View {
  
  var body: some View {
    Form {
      Section("Built-in Transitions") {
        BuiltInTransitions()
      }
      .textCase(nil)
      
      Section("Combining Transitions") {
        CombiningTransitions()
      }
      .textCase(nil)
      
      Section("Custom Transitions") {
        CustomTransitions()
      }
      .textCase(nil)
    }
    .formStyle(.grouped)
  }
}

fileprivate struct BuiltInTransitions: View {
  @State private var show = false
  
  var body: some View {
    VStack {
      Group {
        LabeledContent(".identity") {
          if show {
            GradientCircle()
              .transition(.identity)
          }
        }
        
        LabeledContent(".move") {
          if show {
            GradientCircle()
              .transition(.move(edge: .trailing))
          }
        }
        
        LabeledContent(".push") {
          if show {
            GradientCircle()
              .transition(
                .push(from: .trailing)
              )
          }
        }
        
        LabeledContent(".offset") {
          if show {
            GradientCircle()
              .transition(.offset(x: -30))
          }
        }
        
        LabeledContent(".opacity") {
          if show {
            GradientCircle()
              .transition(.opacity)
          }
        }
        
        LabeledContent(".scale") {
          if show {
            GradientCircle()
              .transition(.scale(scale: 0.1))
          }
        }
        
        LabeledContent(".slide") {
          if show {
            GradientCircle()
              .transition(.slide)
          }
        }
      }
      .frame(height: 44)
    }
    
    Toggle("show", isOn: $show.animation())
  }
}

fileprivate struct GradientCircle: View {
  
  var body: some View {
    Circle()
      .fill(.blue.gradient)
      .frame(height: 30)
  }
}

fileprivate struct CombiningTransitions: View {
  @State private var show = false
  
  var body: some View {
    VStack {
      Group {
        LabeledContent(".combine") {
          if show {
            GradientCircle()
              .transition(
                .opacity
                  .combined(with: .scale(scale: 0.1))
                  .combined(with: .offset(x: -60))
              )
          }
        }
        
        LabeledContent(".asymmetric") {
          if show {
            GradientCircle()
              .transition(
                .asymmetric(
                  insertion:
                      .offset(x: -30)
                      .combined(with: .opacity),
                  removal:
                      .offset(x: 30)
                      .combined(with: .opacity)
                )
              )
          }
        }
        
        LabeledContent(".animation") {
          if show {
            GradientCircle()
              .transition(
                .scale
                  .animation(
                    .spring(response: 0.3, dampingFraction: 0.2)
                  )
              )
          }
        }
      }
      .frame(height: 44)
    }
    
    Toggle("show", isOn: $show.animation())
  }
}

fileprivate struct CustomTransitions: View {
  @State private var show = false
  
  var body: some View {
    VStack {
      Group {
        LabeledContent("custom") {
          if show {
            Image(systemName: "circle.hexagongrid.fill")
              .renderingMode(.original)
              .font(.largeTitle)
              .transition(.customTransiton)
          }
        }
      }
      .frame(height: 80)
    }
    
    Toggle("show", isOn: $show.animation())
  }
}

fileprivate extension AnyTransition {
  
  static var customTransiton: AnyTransition {
    .modifier(
      active: CustomTransitionEffect(degrees: 0),
      identity: CustomTransitionEffect(degrees: 360)
    )
    .combined(with: .opacity)
    .combined(with: .scale)
    .animation(
      .spring(response: 0.3, dampingFraction: 0.2)
    )
  }
}

fileprivate struct CustomTransitionEffect: ViewModifier {
  let degrees: Double
  
  func body(content: Content) -> some View {
    content
      .rotationEffect(.degrees(degrees))
  }
}

struct SampleTransitions_Previews: PreviewProvider {
  static var previews: some View {
    SampleTransitions()
  }
}
