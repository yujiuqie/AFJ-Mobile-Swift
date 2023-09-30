//
//  SampleAdvancedNavigationStack.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/16.
//

import SwiftUI

#if os(iOS)

// MARK: - 使用集合保存 NavigationPath

struct SampleAdvancedNavigationStack: View, Identifiable {
    let id = UUID()
    public let name = "SampleAdvancedNavigationStack"
    
    @StateObject var router = SampleCollectionRouter()
    @State private var isPresented = false
    
    var body: some View {
        NavigationStack(path: $router.path) {
            Form {
                Section {
                    ForEach(router.data, id: \.self) {
                        NavigationLink("\($0)", value: $0 == 2 ? nil : $0)
                    }
                } header: {
                    Text("使用集合保存 NavigationPath")
                        .textCase(nil)
                }
                
                Section {
                    Stepper("栈内新增界面数量：\(router.stepperValue)",
                            value: $router.stepperValue,
                            in: router.stepperRange)
                    
                    Button("跳转") {
                        router.jump()
                    }
                }
                
                Section {
                    Button("使用枚举优化") {
                        isPresented.toggle()
                    }
                    .sheet(isPresented: $isPresented) {
                        SampleAdvancedNavigationStack2()
                    }
                }
            }
            .navigationDestination(for: Int.self) { value in
                VStack(spacing: 20) {
                    Text("Path: \(router.path.description)")
                    
                    if router.isLast {
                        Button("返回栈顶") {
                            router.path = []
                        }
                    }
                }
            }
        }
    }
}

final class SampleCollectionRouter: ObservableObject {
    
    @Published var path: [Int] = []
    @Published var data = [0, 1, 2]
    @Published var stepperValue = 1
    
    var stepperRange: ClosedRange<Int> {
        1...data.count
    }
    
    var isLast: Bool { path.last == data.last }
    
    func jump() {
        addPaths(stepperValue)
    }
    
    private func addPaths(_ count: Int) {
        let paths = data.prefix(stepperValue)
        path.append(contentsOf: paths)
    }
}

// MARK: - 使用枚举优化

struct SampleAdvancedNavigationStack2: View {
    
    // 通过环境变量使 sheet 视图消失
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var router = SampleCollectionRouter2()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            List {
                Section {
                    ForEach(router.orders) { v in
                        NavigationLink(
                            value: SampleCollectionRouter2.Route.order(v)
                        ) {
                            HStack {
                                Image(systemName: v.imgName)
                                    .font(.largeTitle)
                                VStack(alignment: .leading) {
                                    Text(v.name)
                                    Text(v.time)
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text("¥ \(v.paidAmount.formatted())")
                            }
                            .padding([.vertical], 5)
                        }
                    }
                } header: {
                    Text("Orders").textCase(nil)
                }
                
                Section {
                    ForEach(router.recommendation) { v in
                        NavigationLink(
                            value: SampleCollectionRouter2.Route.recommendation(v)
                        ) {
                            HStack {
                                Image(systemName: v.imgName).font(.largeTitle)
                                Text(v.name)
                            }
                        }
                    }
                } header: {
                    Text("Recommendation").textCase(nil)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
            }
            .navigationTitle("AdvancedNavigationStack2")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(
                for: SampleCollectionRouter2.Route.self
            ) { route in
                switch route {
                case let .order(v):
                    Image(systemName: v.imgName)
                        .font(.largeTitle)
                        .navigationTitle(v.name)
                case let .recommendation(v):
                    Image(systemName: v.imgName)
                        .font(.largeTitle)
                        .navigationTitle(v.name)
                }
            }
        }
    }
}

final class SampleCollectionRouter2: ObservableObject {
    
    @Published var path: [Route] = []
    @Published var orders: [Order] = [
        .init(
            name: "Mac Studio",
            imgName: "macstudio",
            time: "2022/9/29",
            paidAmount: 17999
        ),
        .init(
            name: "AirPods Pro 2",
            imgName: "airpodspro",
            time: "2022/10/03",
            paidAmount: 1899
        )
    ]
    @Published var recommendation: [Recommendation] = [
        .init(name: "Apple Watch", imgName: "applewatch")
    ]
}

extension SampleCollectionRouter2 {
    
    enum Route: Hashable {
        case order(Order)
        case recommendation(Recommendation)
    }
    
    struct Order: Hashable, Identifiable {
        let id = UUID()
        var name: String
        var imgName: String
        var time: String
        var paidAmount: CGFloat
    }
    
    struct Recommendation: Hashable, Identifiable {
        let id = UUID()
        var name: String
        var imgName: String
    }
}
#endif

