//
//  SampleGauge.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI

struct SampleGauge: View {
    @State private var speed: Double = 60
    @State private var showLabel = true
    @State private var showCurrent = true
    @State private var showMinMax = true
    private let range = 0.0...200.0
    
    @State private var speedometerValue = 90.0
    
    var body: some View {
        Form {
            Section("GaugeStyle") {
                ForEach(GaugeType.allCases, id: \.self) { type in
                    VStack(alignment: .leading, spacing: 15) {
                        Text(type.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        gauge(type)
                    }
                }
            }
            .textCase(nil)
            
            LabeledContent("Speed") {
                Slider(value: $speed, in: range)
            }
            Toggle("label", isOn: $showLabel)
            Toggle("current", isOn: $showCurrent)
            Toggle("min/max", isOn: $showMinMax)
            
            Section("自定义 GaugeStyle") {
                Gauge(
                    value: speedometerValue,
                    in: range
                ) {
                    Text("KM/H").opacity(0.7)
                } currentValueLabel: {
                    Text("\(speedometerValue, specifier: "%.f")")
                        .font(.largeTitle)
                        .bold()
                } minimumValueLabel: {
                    Text(range.lowerBound.formatted())
                        .foregroundColor(.secondary)
                } maximumValueLabel: {
                    Text(range.upperBound.formatted())
                        .foregroundColor(.secondary)
                }
                .gaugeStyle(.speedometer)
                .frame(maxWidth: .infinity)
                
                Slider(value: $speedometerValue, in: range) {
                    Text("Speed")
                }
            }
            .textCase(nil)
        }
        .formStyle(.grouped)
    }
    
    @ViewBuilder private func gauge(
        _ gaugeType: GaugeType
    ) -> some View {
        let gauge =
        Gauge(
            value: speed,
            in: range
        ) {
            if showLabel {
                Text("Speed (KM/H)")
            }
        } currentValueLabel: {
            if showCurrent {
                Text("\(speed, specifier: "%.f")")
                    .bold()
            }
        } minimumValueLabel: {
            if showMinMax {
                Text(range.lowerBound.formatted())
                    .foregroundColor(.secondary)
            }
        } maximumValueLabel: {
            if showMinMax {
                Text(range.upperBound.formatted())
                    .foregroundColor(.secondary)
            }
        }
        // 渐变色
        .tint(
            LinearGradient(
                colors: [.indigo, .purple, .orange, .red, .red],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        
        switch gaugeType {
        case .automatic:
            gauge.gaugeStyle(.automatic)
        case .accessoryCircular:
            gauge.gaugeStyle(.accessoryCircular)
        case .accessoryCircularCapacity:
            gauge.gaugeStyle(.accessoryCircularCapacity)
        case .linearCapacity:
            gauge.gaugeStyle(.linearCapacity)
        case .accessoryLinear:
            gauge.gaugeStyle(.accessoryLinear)
        case .accessoryLinearCapacity:
            gauge.gaugeStyle(.accessoryLinearCapacity)
        }
    }
}

fileprivate enum GaugeType:
    String, CaseIterable, CustomStringConvertible {
    case automatic
    case accessoryCircular
    case accessoryCircularCapacity
    case linearCapacity
    case accessoryLinear
    case accessoryLinearCapacity
    
    var description: String {
        ".\(rawValue)"
    }
}

fileprivate struct SpeedometerGaugeStyle: GaugeStyle {
    private let gradient = LinearGradient(
        colors: [.green, .orange, .red, .red],
        startPoint: .leading,
        endPoint: .trailing
    )
    private let factor = 1.0/3.0
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .foregroundStyle(.regularMaterial)
            
            Circle()
                .trim(from: factor, to: 1)
                .stroke(
                    gradient,
                    style: .init( lineWidth: 20, dash: [1, 10])
                )
                .rotationEffect(.degrees(180 * factor * 0.5))
                .padding(10)
            
            VStack(spacing: 35) {
                configuration.currentValueLabel
                configuration.label
            }
            .offset(y: -10)
            
            HStack {
                configuration.minimumValueLabel
                Spacer()
                configuration.maximumValueLabel
            }
            .padding(.horizontal, 30)
            .offset(y: 50)
            
            Circle().frame(width: 16)
            
            Circle().foregroundColor(.red).frame(width: 8)
            
            Capsule()
                .foregroundColor(.red)
                .frame(width: 110, height: 2)
                .offset(x: -35)
                .rotationEffect(
                    // configuration.value 范围是 0.0...1.0
                    .degrees(
                        -180 * factor * 0.5 +
                         configuration.value * (1 - factor) * 360
                    )
                )
        }
        .frame(width: 200, height: 200)
        //    .border(Color.secondary.opacity(0.5))
    }
}

fileprivate extension GaugeStyle
where Self == SpeedometerGaugeStyle {
    static var speedometer: Self { .init() }
}

struct SampleGauge_Previews: PreviewProvider {
    static var previews: some View {
        SampleGauge()
            .preferredColorScheme(.dark)
    }
}

