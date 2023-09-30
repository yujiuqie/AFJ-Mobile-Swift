//
//  SampleNavigationStackRestore.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/16.
//

import SwiftUI

#if os(iOS)
struct SampleNavigationStackRestore: View, Identifiable {
    let id = UUID()
    public let name = "SampleNavigationStackRestore"
    
    @StateObject private var router = SampleRestoreRouter()
    private let str = "Stay Hungry, Stay Foolish!"
    private let weather = Weather(name: "sun.max.fill", degree: 32.0)
    
    var body: some View {
        NavigationStack(path: $router.path) {
            List {
                Section {
                    NavigationLink(value: SampleRestoreRouter.Route.string(str)) {
                        Text(str)
                    }
                    NavigationLink(value: SampleRestoreRouter.Route.weather(weather)) {
                        Label(weather.degreeCelsius, systemImage: weather.name)
                    }
                }
                
                Section {
                    Button("跳转两个页面") {
                        router.path.append(SampleRestoreRouter.Route.string(str))
                        router.path.append(SampleRestoreRouter.Route.weather(weather))
                    }
                }
            }
            .navigationDestination(
                for: SampleRestoreRouter.Route.self
            ) { route in
                switch route {
                case let .string(value):
                    Text(value)
                case let .weather(value):
                    Label(value.degreeCelsius, systemImage: value.name)
                }
            }
        }
    }
}

extension SampleNavigationStackRestore {
    
    struct Weather: Codable, Hashable {
        var name: String
        var degree: Double
        
        var degreeCelsius: String {
            degree.celsiusFormat
        }
    }
}

final class SampleRestoreRouter: ObservableObject {
    
    // 1
    var path = NavigationPath() {
        willSet {
            objectWillChange.send()
        }
        didSet {
            save()
        }
    }
    
    // 2
    @AppStorage("naviPathStore") private var naviPathStore: Data?
    
    private func readSerializedData() -> Data? {
        naviPathStore
    }
    
    private func writeSerializedData(_ data: Data) {
        naviPathStore = data
    }
    
    // 3
    init() {
        if let data = self.readSerializedData() {
            printLog(String(decoding: data, as: UTF8.self))
            do {
                let representation = try JSONDecoder().decode(
                    NavigationPath.CodableRepresentation.self,
                    from: data)
                self.path = NavigationPath(representation)
            } catch {
                self.path = NavigationPath()
            }
        } else {
            self.path = NavigationPath()
        }
    }
    
    // 4
    func save() {
        guard let representation = path.codable else { return }
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(representation)
            self.writeSerializedData(data)
            printLog(String(decoding: data, as: UTF8.self))
        } catch {
            printLog(error)
        }
    }
}

extension SampleRestoreRouter {
    
    enum Route: Codable, Hashable {
        case string(String)
        case weather(SampleNavigationStackRestore.Weather)
    }
}
#endif
