//
//  SampleSceneLifeCycle.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/16.
//

import SwiftUI

#if os(iOS)
typealias Application = UIApplication
#elseif os(macOS)
typealias Application = NSApplication
#endif

struct SampleSceneLifeCycle: View, Identifiable {
    let id = "SampleSceneLifeCycle"
    public let name = "SampleSceneLifeCycle"
    
    @Environment(\.scenePhase) private var scenePhase
    @State private var phases = [String]()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if phases.isEmpty {
                    TipsView(
                        iOSTips: "试试将 app 挂起、恢复、退至后台...",
                        macOSTips: "试试将窗口最小化、还原..."
                    )
                }
                ForEach(phases, id: \.self) {
                    Text($0).padding(5)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .onChange(of: scenePhase) { newValue in
            printLog(newValue)
            switch newValue {
            case .inactive:
                phases.append("🟡 inactive")
            case .background:
                phases.append("🔴 background")
            case .active:
                phases.append("🟢 active")
            @unknown default:
                phases.append("unknown")
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: Application.willResignActiveNotification)
        ) { value in
            printLog(value.name.rawValue)
        }
    }
}

struct SampleSceneLifeCycle_Previews: PreviewProvider {
    static var previews: some View {
        SampleSceneLifeCycle().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

