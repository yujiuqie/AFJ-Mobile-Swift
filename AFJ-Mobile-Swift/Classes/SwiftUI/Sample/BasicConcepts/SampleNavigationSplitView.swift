//
//  SampleNavigationSplitView.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/16.
//

import SwiftUI

struct SampleNavigationSplitView: View, Identifiable {
    let id = UUID()
    public let name = "SampleNavigationSplitView"
    
    @StateObject private var vm = SplitVM()
    
    var body: some View {
        vm.splitColumns.view
            .environmentObject(vm)
    }
}

fileprivate final class SplitVM: ObservableObject {
    @Published var splitColumns: SplitColumns = .two
}

// MARK: - Two Columns

fileprivate final class TwoColumnsVM: BaseColumnsVM {
    @Published var data: [Book] = BookCategory.mock.first!.books
}

fileprivate struct TwoColumnsSplitView: View {
    @StateObject private var vm = TwoColumnsVM()
    
    var body: some View {
        NavigationSplitView(columnVisibility: $vm.columnVisibility) {
            Group {
                if vm.isMultiSelection {
                    List(vm.data, selection: $vm.bookMultiSelection) { book in
                        BookView(book: book)
                    }
                } else {
                    List(vm.data, selection: $vm.bookSelection) { book in
                        BookView(book: book)
                    }
                }
            }
            .navigationSplitViewColumnWidth(min: 200, ideal: 200, max: 300)
            .sidebar(navigationTitle: "书籍", columnsVm: vm)
        } detail: {
            SampleDetailView(vm: vm)
        }
    }
}

// MARK: - Three Columns

fileprivate final class ThreeColumnsVM: BaseColumnsVM {
    @Published var data: [BookCategory] = BookCategory.mock
    @Published var leadingSelection: BookCategory?
}

fileprivate struct SampleThreeColumnsSplitView: View {
    @StateObject private var vm = ThreeColumnsVM()
    
    var body: some View {
        NavigationSplitView(columnVisibility: $vm.columnVisibility) {
            List(vm.data, selection: $vm.leadingSelection) { category in
                Label(category.name, systemImage: "books.vertical")
            }
            .sidebar(navigationTitle: "分类", columnsVm: vm)
        } content: {
            if vm.isMultiSelection {
                List(vm.leadingSelection?.books ?? [], selection: $vm.bookMultiSelection) { book in
                    BookView(book: book)
                }
            } else {
                List(vm.leadingSelection?.books ?? [], selection: $vm.bookSelection) { book in
                    BookView(book: book)
                }
            }
        } detail: {
            SampleDetailView(vm: vm)
        }
    }
}

// MARK: - Shared

// MARK: Modifiers

struct SideBarModifier: ViewModifier {
    let navigationTitle: String
    @StateObject fileprivate var columnsVm: BaseColumnsVM
    @EnvironmentObject private var splitVm: SplitVM
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                Menu {
                    Picker("切换", selection: $splitVm.splitColumns) {
                        ForEach(SplitColumns.allCases, id: \.self) { item in
                            LabeledContent(item.rawValue) {
                                Image(systemName: item.image)
                            }
                        }
                    }
                    Picker("选择", selection: $columnsVm.isMultiSelection) {
                        Text("单选").tag(false)
                        Text("多选").tag(true)
                    }
                    Menu("columnVisibility") {
                        Picker(
                            "columnVisibility",
                            selection: $columnsVm.columnVisibilitySelection
                        ) {
                            ForEach(ColumnVisibility.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
            .navigationTitle(navigationTitle)
    }
}

extension View {
    
    fileprivate func sidebar(
        navigationTitle: String,
        columnsVm: BaseColumnsVM
    ) -> some View {
        modifier(
            SideBarModifier(
                navigationTitle: navigationTitle,
                columnsVm: columnsVm
            )
        )
    }
}

// MARK: View

fileprivate struct BookView: View {
    let book: Book
    
    var body: some View {
        ZStack {
            randomGradient
                .cornerRadius(10)
            Text(book.name)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
        }
        .padding()
        .aspectRatio(3/4, contentMode: .fill)
    }
    
    private var randomGradient: LinearGradient {
        let createGradient: ([Color]) -> LinearGradient = { colors in
            LinearGradient(
                colors: colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        return [
            createGradient([.gray, .black]),
            createGradient([.blue, .purple]),
            createGradient([.red, .orange]),
            createGradient([.indigo, .cyan]),
        ].randomElement()!
    }
}

fileprivate struct SampleDetailView: View {
    @StateObject var vm: BaseColumnsVM
    
    var body: some View {
        if vm.isMultiSelection {
            ScrollView {
                Text("""
        Mac:
        单选：鼠标单击
        多选：按住 ⌘ 连续单选/反选，按住 ⇧ 一次选中多个
        
        iPhone、iPad:
        单选：单指点击
        多选：双指滑动
        """)
                .padding()
                .foregroundColor(.secondary)
                Text("""
          已选择 \(vm.bookMultiSelection.count) 本书籍:\n
          \(vm.bookMultiSelection.map { "《\($0.name)》" }
          .joined(separator: "\n"))
          """)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle("多选")
        } else {
            ScrollView {
                Text(vm.bookSelection?.name ?? "请选择书籍")
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle("单选")
        }
    }
}

// MARK: Model

fileprivate enum SplitColumns: String, CaseIterable {
    case two = "双栏"
    case three = "三栏"
    
    var image: String {
        switch self {
        case .two:
            return "sidebar.left"
        case .three:
            return "rectangle.split.3x1"
        }
    }
    
    @ViewBuilder var view: some View {
        switch self {
        case .two:
            TwoColumnsSplitView()
        case .three:
            SampleThreeColumnsSplitView()
        }
    }
}

fileprivate struct BookCategory: Identifiable, Hashable {
    var id: Self { self }
    var name: String
    var books: [Book]
    
    static var mock: [Self] {
        [
            .init(name: "文学", books: [
                .init(name: "三国演义"),
                .init(name: "红楼梦"),
                .init(name: "西游记"),
                .init(name: "水浒传"),
            ]),
            .init(name: "技术", books: [
                .init(name: "iOS 从入门到放弃"),
                .init(name: "21 天精通 Web 3.0")
            ])
        ]
    }
}

fileprivate struct Book: Identifiable, Hashable {
    var id: Self { self }
    var name: String
}

fileprivate enum ColumnVisibility: String, CaseIterable {
    case automatic = "automatic"
    case all = "all"
    case doubleColumn = "doubleColumn"
    case detailOnly = "detailOnly"
    
    var columnVisibility: NavigationSplitViewVisibility {
        switch self {
        case .automatic:
            return .automatic
        case .all:
            return .all
        case .doubleColumn:
            return .doubleColumn
        case .detailOnly:
            return .detailOnly
        }
    }
}

// MARK: VM

fileprivate class BaseColumnsVM: ObservableObject {
    
    @Published var isMultiSelection = false
    
    @Published var columnVisibility = NavigationSplitViewVisibility.all
    @Published var columnVisibilitySelection = ColumnVisibility.automatic {
        didSet {
            columnVisibility = columnVisibilitySelection.columnVisibility
        }
    }
    
    @Published var bookSelection: Book?
    @Published var bookMultiSelection: Set<Book> = []
}



struct SampleNavigationSplitView_Previews: PreviewProvider {
    static var previews: some View {
        SampleNavigationSplitView()
            .previewInterfaceOrientation(.portrait)
    }
}
