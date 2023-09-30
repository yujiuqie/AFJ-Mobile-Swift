//
//  SampleViewLifeCycle.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/19.
//

import SwiftUI
import Combine

struct SampleViewLifeCycle: View {
    @StateObject private var vm = ViewModel()
    private let delay = 3
    
    var body: some View {
        Form {
            Section {
                NavigationLink {
                    View2 {
                        vm.events.append(
                            .init(name: "【onAppear】View2⃣️")
                        )
                    } onDisappear: {
                        vm.events.append(
                            .init(name: "【onDisappear】View2⃣️")
                        )
                    } taskEvent: { event in
                        vm.events.append(event)
                    }
                } label: {
                    Text("view1⃣️")
                }
                
                LabeledContent("当前随机数：\(vm.randomNumber)") {
                    Button("生成 0-1 之间的随机数") {
                        vm.randomNumber = (0..<2).randomElement()!
                        vm.number += vm.randomNumber
                    }
                    .buttonStyle(.borderless)
                }
                
                LabeledContent("当前 taskId：\(vm.taskId)") {
                    Button("改变 taskId") {
                        vm.taskId += 1
                        vm.events.append(
                            .init(name: "【taskId】changed: \(vm.taskId)")
                        )
                    }
                    .buttonStyle(.borderless)
                }
            } footer: {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(vm.events) { event in
                            Text(event.name)
                        }
                    }
                }
            }
        }
        .formStyle(.grouped)
        .onAppear {
            vm.events.append(
                .init(name: "【onAppear】view1⃣️")
            )
        }
        .onChange(of: vm.number) { newValue in
            vm.events.append(
                .init(name: "【onChange】number： \(vm.number)")
            )
        }
        .onReceive(vm.$number) { output in
            vm.events.append(
                .init(name: "【onReceive】number： \(vm.number)")
            )
        }
        .task {
            try? await Task.sleep(for: .seconds(delay))
            vm.events.append(
                .init(name: "【task】View1⃣️ task end after \(delay)s.")
            )
        }
        .task(id: vm.taskId) {
            do {
                try await Task.sleep(for: .seconds(delay))
                vm.events.append(
                    .init(name: "【task \(vm.taskId)】End after \(delay)s.")
                )
            } catch {
                printLog(error)
                vm.events.append(
                    .init(name: "【task \(vm.taskId - 1)】Cancelled")
                )
            }
        }
    }
}

fileprivate struct Event: Identifiable {
    let id = UUID()
    var name: String
}

fileprivate final class ViewModel: ObservableObject {
    @Published var number = 0
    @Published var randomNumber = 0
    @Published var events: [Event] = []
    @Published var taskId = 999
}

fileprivate struct View2: View {
    let onAppear: () -> Void
    let onDisappear: () -> Void
    let taskEvent: (Event) -> Void
    
    var body: some View {
        Text("View2⃣️")
            .onAppear {
                onAppear()
            }
            .onDisappear {
                onDisappear()
            }
            .task {
                do {
                    try await Task.sleep(for: .seconds(2))
                    taskEvent(.init(name: "【task】View2⃣️ task end after 2s."))
                } catch {
                    printLog(error)
                    taskEvent(.init(name: "【task】View2⃣️ task cancelled"))
                }
            }
    }
}

struct SampleViewLifeCycle_Previews: PreviewProvider {
    static var previews: some View {
        SampleViewLifeCycle()
    }
}

