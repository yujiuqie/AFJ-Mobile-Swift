//
//  SampleCustomLayout.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/27.
//

import SwiftUI

struct SampleCustomLayout: View {
    
    var body: some View {
        Form {
            Section("CustomLayout") {
                NavigationLink("CustomGridLayout") {
                    CustomGridView()
                }
            }
            .textCase(nil)
            
            Section("AnyLayout") {
                NavigationLink("LayoutTransition") {
                    LayoutTransition()
                }
            }
            .textCase(nil)
            
            Section("WaterFallGrid") {
                NavigationLink("WaterFallGrid") {
                    WaterFallGridView()
                }
            }
            .textCase(nil)
        }
        .formStyle(.grouped)
    }
}

fileprivate struct CustomGridView: View {
    @State private var gridWidth: CGFloat = 260
    @State private var hSpacing: CGFloat = 10
    @State private var vSpacing: CGFloat = 10
    private var itemWidths: [CGFloat] = {
        let count = 200
        var itemWidths = [CGFloat]()
        for _ in 0..<count {
            itemWidths.append(.random(in: 50...80))
        }
        return itemWidths
    }()
    private var tags: [String] = {
        let count = 200
        var tags = [String]()
        for _ in 0..<count {
            tags.append(
                ["A", "B", "C", "D", "E"]
                    .prefix(.random(in: 1..<5))
                    .joined()
            )
        }
        return tags
    }()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            CustomGridLayout(hSpacing: hSpacing, vSpacing: vSpacing) {
                ForEach(0..<tags.count, id: \.self) { i in
                    Text(tags[i])
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .background(.blue.gradient)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            }
            .frame(width: gridWidth)
        }
        .animation(.default, value: gridWidth)
        .animation(.default, value: hSpacing)
        .animation(.default, value: vSpacing)
        .safeAreaInset(edge: .bottom) {
            VStack {
                LabeledContent("gridWidth: \(gridWidth, specifier: "%.f")") {
                    Slider(value: $gridWidth, in: 200...350)
                }
                LabeledContent("hSpacing: \(hSpacing, specifier: "%.f")") {
                    Slider(value: $hSpacing, in: 0...20)
                }
                LabeledContent("vSpacing: \(vSpacing, specifier: "%.f")") {
                    Slider(value: $vSpacing, in: 0...20)
                }
            }
            .padding()
            .background(.bar)
        }
        
    }
}

fileprivate struct CustomGridLayout: Layout {
    var hSpacing: CGFloat = 10
    var vSpacing: CGFloat = 10
    
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        var finalWidth: CGFloat = 0
        var finalHeight: CGFloat = 0
        
        // 最大宽度
        var maxWidth: CGFloat = 0
        // 当前行高
        var rowHeight: CGFloat = 0
        
        for size in sizes {
            if maxWidth + size.width + hSpacing > (proposal.width ?? 0) {
                // 换行
                finalHeight += rowHeight + vSpacing
                maxWidth = size.width
                rowHeight = size.height
            } else {
                maxWidth += size.width + hSpacing
                rowHeight = max(rowHeight, size.height)
            }
            finalWidth = max(finalWidth, maxWidth)
        }
        finalHeight += rowHeight
        return .init(width: finalWidth, height: finalHeight)
    }
    
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        var x = bounds.minX
        var y = bounds.minY
        var maxHeight: CGFloat = 0
        
        for i in subviews.indices {
            let size = sizes[i]
            if x + size.width > (proposal.width ?? 0) {
                // 换行
                y += maxHeight + vSpacing
                x = bounds.minX
                maxHeight = 0
            }
            
            subviews[i].place(
                at: .init(x: x, y: y),
                anchor: .topLeading,
                proposal: .init(size)
            )
            
            x += size.width + hSpacing
            maxHeight = max(maxHeight, size.height)
        }
    }
}

fileprivate struct LayoutTransition: View {
    @State private var anyLayoutType = BuiltInLayoutType.hStackLayout
    
    private let gradientColors = [
        Color.red.gradient,
        Color.green.gradient,
        Color.blue.gradient,
        Color.teal.gradient,
        Color.purple.gradient,
    ]
    
    var body: some View {
        return VStack {
            anyLayoutType.layout {
                row(range: 0..<gradientColors.count/2)
                row(range: gradientColors.count/2..<gradientColors.count)
            }
            .animation(.spring(), value: anyLayoutType)
            .frame(maxHeight: .infinity)
            .safeAreaInset(edge: .bottom) {
                LabeledContent("AnyLayout") {
                    Picker("AnyLayout", selection: $anyLayoutType) {
                        ForEach(BuiltInLayoutType.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .labelsHidden()
                }
                .padding()
                .background(.bar)
            }
        }
    }
    
    private func row(range: Range<Int>) -> some View {
        GridRow {
            ForEach(range, id: \.self) { i in
                RoundedRectangle(cornerRadius: 10)
                    .fill(gradientColors[i])
                    .frame(width: width, height: height)
                    .rotationEffect(.degrees(degrees(at: i)))
            }
        }
    }
    
    private var width: CGFloat {
        anyLayoutType == .zStackLayout ? 20 : 40
    }
    
    private var height: CGFloat {
        anyLayoutType == .zStackLayout ? 100 : 60
    }
    
    private func degrees(at index: Int) -> Double {
        switch anyLayoutType {
        case .hStackLayout:
            return 30
        case .vStackLayout:
            return -30
        case .zStackLayout:
            return Double(360/gradientColors.count * index)
        case .gridLayout:
            return 0
        }
    }
}

fileprivate enum BuiltInLayoutType: String, CaseIterable {
    case hStackLayout
    case vStackLayout
    case zStackLayout
    case gridLayout
    
    var layout: AnyLayout {
        switch self {
        case .hStackLayout:
            return AnyLayout(HStackLayout())
        case .vStackLayout:
            return AnyLayout(VStackLayout())
        case .zStackLayout:
            return AnyLayout(ZStackLayout())
        case .gridLayout:
            return AnyLayout(GridLayout())
        }
    }
}

fileprivate struct WaterFallGridView: View {
    @State private var columnsCount = 3
    
    var body: some View {
        var items = [WaterFallGrid.Item]()
        for i in 0..<100 {
            let height = CGFloat.random(in: 100...300)
            items.append(.init(height: height, title: String(i)))
        }
        return ScrollView {
            WaterFallGrid(
                items: items,
                columnsCount: columnsCount
            )
            .padding(.horizontal)
        }
        .safeAreaInset(edge: .bottom) {
            LabeledContent("columnsCount") {
                Picker("columnsCount", selection: $columnsCount) {
                    ForEach(1...5, id: \.self) {
                        Text("\($0)")
                    }
                }
                .labelsHidden()
                .pickerStyle(.segmented)
            }
            .padding()
            .background(.bar)
        }
    }
}

fileprivate struct WaterFallGrid: View {
    struct Column: Identifiable {
        let id = UUID()
        var items = [Item]()
    }
    
    struct Item: Identifiable {
        let id = UUID()
        let height: CGFloat
        let title: String
    }
    
    let columns: [Column]
    let hSpacing: CGFloat
    let vSpacing: CGFloat
    
    init(
        items: [Item],
        columnsCount: Int,
        hSpacing: CGFloat = 10,
        vSpacing: CGFloat = 10
    ) {
        var columns = [Column]()
        var columnsHeights = [CGFloat]()
        for _ in 0..<columnsCount {
            columns.append(Column())
            columnsHeights.append(0)
        }
        
        for item in items {
            // 高度最短的列，假设为第一列
            var minColumnIndex = 0
            // 最短列的高度，假设为第一列
            var minColumnHeight = columnsHeights.first!
            for i in 1..<columnsHeights.count {
                let curHeight = columnsHeights[i]
                // 找出当前最短的列，更新至变量
                if curHeight < minColumnHeight {
                    minColumnIndex = i
                    minColumnHeight = curHeight
                }
            }
            
            // 将 item 添加至最短的列，同时更新最短列的高度
            columns[minColumnIndex].items.append(item)
            columnsHeights[minColumnIndex] += item.height
        }
        
        self.hSpacing = hSpacing
        self.vSpacing = vSpacing
        self.columns = columns
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: hSpacing) {
            ForEach(columns, id: \.id) { column in
                LazyVStack(spacing: vSpacing) {
                    ForEach(column.items) { item in
                        Text(item.title)
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity)
                            .frame(height: item.height)
                            .background(.blue.gradient)
                    }
                }
            }
        }
    }
}

struct SampleCustomLayout_Previews: PreviewProvider {
    static var previews: some View {
        SampleCustomLayout()
    }
}

