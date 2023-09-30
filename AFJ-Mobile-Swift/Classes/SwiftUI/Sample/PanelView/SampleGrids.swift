//
//  SampleGrids.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/27.
//

import SwiftUI

struct SampleGrids: View {
    
    var body: some View {
        Form {
            Section("Grid") {
                Grid1()
            }
            .textCase(nil)
            
            Section {
                Grid2()
            }
            
            Section {
                Grid3()
            }
            
            Section("LazyHGrid") {
                NavigationLink("LazyHGrid") {
                    LazyHGridView()
                }
            }
            .textCase(nil)
            
            Section("LazyVGrid") {
                NavigationLink("LazyVGrid") {
                    LazyVGridView()
                }
            }
            .textCase(nil)
        }
        .formStyle(.grouped)
    }
}

fileprivate struct Grid1: View {
    @State private var gridAlignment: GridAlignment = .center
    @State private var hSpacing: CGFloat = 15.0
    @State private var vSpacing: CGFloat = 15.0
    @State private var gridRowAlignment = GridRowAlignment.center
    
    var body: some View {
        Grid(
            alignment: gridAlignment.alignment,
            horizontalSpacing: hSpacing,
            verticalSpacing: vSpacing
        ) {
            GridRow {
                ForEach(0..<2, id: \.self) { _ in
                    Rectangle()
                        .fill(.red.gradient)
                        .frame(width: 50, height: 50)
                }
            }
            GridRow {
                ForEach(0..<3, id: \.self) { i in
                    Rectangle()
                        .fill(.green.gradient)
                        .frame(
                            width: 50 + 20 * CGFloat(i-1),
                            height: 50 + 20 * CGFloat(i-1)
                        )
                }
            }
            GridRow(alignment: gridRowAlignment.alignment) {
                ForEach(0..<4, id: \.self) { i in
                    Rectangle()
                        .fill(.blue.gradient)
                        .frame(
                            width: 50 + 10 * CGFloat(i % 2-1),
                            height: 50 + 10 * CGFloat(i % 2-1)
                        )
                }
            }
        }
        
        LabeledContent("hSpacing: \(hSpacing, specifier: "%.1f")") {
            Slider(value: $hSpacing, in: 0.0...20)
        }
        
        LabeledContent("vSpacing: \(vSpacing, specifier: "%.1f")") {
            Slider(value: $vSpacing, in: 0.0...20)
        }
        
        Picker("Grid Alignment", selection: $gridAlignment) {
            ForEach(GridAlignment.allCases, id: \.self) {
                Text($0.rawValue)
            }
        }
        
        Picker("GridRow Alignment", selection: $gridRowAlignment) {
            ForEach(GridRowAlignment.allCases, id: \.self) {
                Text($0.rawValue)
            }
        }
    }
}

fileprivate struct Grid2: View {
    
    var body: some View {
        Grid {
            GridRow {
                Rectangle()
                    .fill(.red.gradient)
                    .frame(width: 50, height: 50)
                Rectangle()
                    .fill(.red.gradient)
                    .frame(width: 50, height: 50)
                    .gridCellColumns(2)
            }
            
            GridRow {
                // 空白占位格
                Color.clear
                    .gridCellUnsizedAxes(.horizontal)
                    .gridCellColumns(2)
                Rectangle()
                    .fill(.green.gradient)
                    .frame(width: 50, height: 50)
            }
            
            GridRow {
                Rectangle()
                    .fill(.blue.gradient)
                    .frame(width: 50, height: 50)
                Rectangle()
                    .fill(.blue.gradient)
                    .frame(width: 50, height: 50)
                Rectangle()
                    .fill(.blue.gradient)
                    .frame(width: 50, height: 50)
            }
        }
    }
}

fileprivate struct Grid3: View {
    
    var body: some View {
        Grid(alignment: .trailing) {
            GridRow {
                Text("手机")
                Text("155********")
                    .gridColumnAlignment(.leading)
            }
            GridRow {
                Text("电子邮箱")
                Text("xxxxxx@outlook.com")
            }
        }
    }
}

fileprivate struct LazyHGridView: View {
    private let rows = [
        // 自适应尺寸，最小高度为 60，根据视图的尺寸生成尽可能多的 item
        [GridItem(.adaptive(minimum: 60))],
        
        // 三行，每行固定 item 高度为 80
        Array(repeating: GridItem(.fixed(80)), count: 3),
        
        // 三行，因 .flexible 默认最最大高度为无限大，所以会撑满视图
        Array(repeating: GridItem(.flexible(minimum: 60)), count: 3),
        
        // 第一行固定高度为 100，后面的 item 最小高度为 50，生成尽可能多的 item
        [GridItem(.fixed(100)), GridItem(.adaptive(minimum: 50))],
        
        // 第一行固定高度为 80，第二行因为是 .flexible，所以会撑满剩余空间
        [GridItem(.fixed(80)), GridItem(.flexible(minimum: 60))],
        
        // 第一行固定高度为 120，第二行虽然是 .flexible，并不会撑满视图，因为后面还有 .adaptive, 其最小高度为 40，它的优先级最高，所以第二行的高度为 80
        [GridItem(.fixed(120)), GridItem(.flexible(maximum: 80)), GridItem(.adaptive(minimum: 40))]
    ]
    private let displayedRows = ["adaptive", "fixed", "flexible", "mix1", "mix2", "mix3"]
    @State private var rowsSelection = 0
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows[rowsSelection]) {
                ForEach(0..<999, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 5)
                        .fill(
                            [Color.red, Color.green, Color.blue]
                                .randomElement()!.gradient
                        )
                        .frame(minWidth: 40, maxWidth: .infinity)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Picker("rows", selection: $rowsSelection) {
                ForEach(0..<displayedRows.count, id: \.self) { i in
                    Text(displayedRows[i]).tag(i)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.bar)
        }
    }
}

fileprivate struct LazyVGridView: View {
    private let columns = [
        [GridItem(.adaptive(minimum: 60))],
        Array(repeating: GridItem(.fixed(80)), count: 3),
        Array(repeating: GridItem(.flexible(minimum: 60)), count: 3),
        [GridItem(.fixed(100)), GridItem(.adaptive(minimum: 50))],
        [GridItem(.fixed(80)), GridItem(.flexible(minimum: 60))],
        [GridItem(.fixed(120)), GridItem(.flexible(maximum: 80)), GridItem(.adaptive(minimum: 40))]
    ]
    private let displayedColumns = ["adaptive", "fixed", "flexible", "mix1", "mix2", "mix3"]
    @State private var columnsSelection = 0
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns[columnsSelection]) {
                ForEach(0..<999, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 5)
                        .fill(
                            [Color.red, Color.green, Color.blue]
                                .randomElement()!.gradient
                        )
                        .frame(maxWidth: .infinity, minHeight: 40)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Picker("columns", selection: $columnsSelection) {
                ForEach(0..<displayedColumns.count, id: \.self) { i in
                    Text(displayedColumns[i]).tag(i)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.bar)
        }
    }
}

fileprivate enum GridRowAlignment: String, CaseIterable {
    case center
    case top
    case bottom
    
    var alignment: VerticalAlignment {
        switch self {
        case .center:
            return .center
        case .top:
            return .top
        case .bottom:
            return .bottom
        }
    }
}

fileprivate enum GridAlignment: String, CaseIterable {
    case center
    case top
    case bottom
    case leading
    case trailing
    case topLeading
    case topTrailing
    case bottomLeading
    case bottomTrailing
    
    var alignment: Alignment {
        switch self {
        case .center:
            return .center
        case .top:
            return .top
        case .bottom:
            return .bottom
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        case .topLeading:
            return .topLeading
        case .topTrailing:
            return .topTrailing
        case .bottomLeading:
            return .bottomLeading
        case .bottomTrailing:
            return .bottomTrailing
        }
    }
}

struct SampleGrids_Previews: PreviewProvider {
    static var previews: some View {
        SampleGrids()
    }
}


