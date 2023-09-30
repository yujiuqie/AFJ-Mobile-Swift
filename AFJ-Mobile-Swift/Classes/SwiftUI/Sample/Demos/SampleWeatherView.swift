//
//  SampleWeatherView.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/17.
//

import SwiftUI

struct Weather: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var icon: String
    var temperature: Double
    
    static var mock: [Self] {
        [
            .init(name: "Sun", icon: "sun.max.fill", temperature: 32),
            .init(name: "Rain", icon: "cloud.rain.fill", temperature: 26),
            .init(name: "Snow", icon: "snowflake", temperature: -2),
        ]
    }
}

struct SampleWeatherView: View {
    @State private var weathers = Weather.mock
    
    var body: some View {
        List(weathers, id: \.name){
            Label($0.name, systemImage:  $0.icon)
        }
    }
}

struct SampleWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        SampleWeatherView()
    }
}
