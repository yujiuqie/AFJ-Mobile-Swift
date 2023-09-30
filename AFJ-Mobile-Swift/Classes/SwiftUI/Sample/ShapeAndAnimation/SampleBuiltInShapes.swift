import SwiftUI

struct SampleBuiltInShapes: View {
    @State private var isCircular = true
    
    var body: some View {
        Form {
            Section("Rectangle") {
                Rectangle()
                    .frame(width: 150, height: 90)
            }
            .textCase(nil)
            
            Section("RoundedRectangle") {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 150, height: 90)
            }
            .textCase(nil)
            
            Section("Circle") {
                Circle()
                    .frame(height: 90)
            }
            .textCase(nil)
            
            Section("Ellipse") {
                Ellipse()
                    .frame(width: 150, height: 70)
            }
            .textCase(nil)
            
            Section("Capsule") {
                Capsule()
                    .frame(width: 120, height: 50)
            }
            .textCase(nil)
            
            Section("AnyShape") {
                AnyShapeView(isCircular: $isCircular)
                    .frame(width: 150, height: 90)
                Toggle("isCircular", isOn: $isCircular)
            }
            .textCase(nil)
        }
        .formStyle(.grouped)
    }
}

fileprivate struct AnyShapeView: View {
    @Binding var isCircular: Bool
    
    var body: some Shape {
        isCircular
        ? AnyShape(Circle())
        : AnyShape(Capsule())
    }
}

struct SampleBuiltInShapes_Previews: PreviewProvider {
    static var previews: some View {
        SampleBuiltInShapes()
    }
}
