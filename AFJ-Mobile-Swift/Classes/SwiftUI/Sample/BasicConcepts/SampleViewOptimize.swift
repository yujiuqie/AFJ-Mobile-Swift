//
//  SampleViewOptimize.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/20.
//

import SwiftUI

struct SampleViewOptimize: View {
    
    @State private var isVip1 = false
    @State private var isVip2 = false
    @State private var cityName = "Shenzhen"
    @State private var weather = Weather.mock.first!
    
    var body: some View {
        Form {
            Section("Conditional view") {
                HStack {
                    if isVip1 {
                        HStack {
                            Text("Bruce")
                            Text(Image(systemName: "crown.fill"))
                        }
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(10)
                    } else {
                        Text("Bruce")
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $isVip1.animation(.easeInOut(duration: 0.5)))
                }
                
                HStack {
                    HStack {
                        Text("Bruce")
                        Text(Image(systemName: "crown.fill"))
                            .opacity(isVip2 ? 1 : 0)
                    }
                    .padding(isVip2 ? 10 : 0)
                    .background(isVip2 ? Color.purple : Color.clear)
                    .cornerRadius(10)
                    
                    Spacer()
                    
                    Toggle("", isOn: $isVip2.animation(.easeInOut(duration: 0.5)))
                }
            }
            .textCase(nil)
            
            Section("EquatableView") {
                VStack(spacing: 10) {
                    CityNameView(name: cityName)
                    
                    WeatherView(weather: weather)
                        .equatable()
                    // 上面是的写法等同于：
                    // EquatableView(content: WeatherView(weather: weather))
                    
                    Spacer(minLength: 10)
                    
                    Button("刷新视图") {
                        cityName = "Shenzhen"
                        weather = Weather.mock.randomElement()!
                    }
#if os(iOS)
                    .buttonStyle(.borderless)
#endif
                    
                    Text("试试运行代码，观察控制台的输出")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            }
            .textCase(nil)
        }
        .formStyle(.grouped)
    }
}

extension SampleViewOptimize {
    
    struct CityNameView: View {
        
        let name: String
        
        var body: some View {
            printLog("refresh")
            return Text(name).font(.title)
        }
    }
    
    struct WeatherView: View, Equatable {
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.weather.name == rhs.weather.name &&
            lhs.weather.temperature == rhs.weather.temperature
        }
        
        let weather: Weather
        
        var body: some View {
            printLog("refresh")
            return Label(
                // 温度数字 格式化
                weather.temperature.celsiusFormat,
                systemImage: weather.icon
            )
        }
    }
}

struct SampleViewOptimize_Previews: PreviewProvider {
    static var previews: some View {
        SampleViewOptimize()
    }
}
