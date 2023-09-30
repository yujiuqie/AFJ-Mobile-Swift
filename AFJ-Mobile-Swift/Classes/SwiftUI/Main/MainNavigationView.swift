//
//  MainNavigationView.swift
//  AFJ-Mobile-Swift
//
//  Created by viktyz on 2023/8/17.
//

import SwiftUI

struct MainNavigationView: View {
    
    @State var title: String
    
    var body: some View {
        NavigationView {
            List {
                Section("SwiftUI"){
                    NavigationLink {
                        BasicNavigationView(title: "基础概念")
                    } label: {
                        Text("基础概念")
                    }
                    NavigationLink {
                        BasicViewNavigationView(title: "基础视图")
                    } label: {
                        Text("基础视图")
                    }
                    NavigationLink {
                        PanelViewNavigationView(title: "视图容器")
                    } label: {
                        Text("视图容器")
                    }
                    NavigationLink {
                        ViewLayoutNavigationView(title: "视图布局")
                    } label: {
                        Text("视图布局")
                    }
                    NavigationLink {
                        ShapeViewNavigationView(title: "图形图表")
                    } label: {
                        Text("图形图表")
                    }
                    NavigationLink {
                        AnimationViewNavigationView(title: "动画实现")
                    } label: {
                        Text("动画实现")
                    }
                    NavigationLink {
                        GestureViewNavigationView(title: "手势")
                    } label: {
                        Text("手势")
                    }
                }
                Section("示例 Demo"){
                    MainContentViewItem(title: "Recipes") {
                        SampleRecipes()
                    }
                    MainContentViewItem(title: "Languages") {
                        SampleLanguageView()
                    }
                    MainContentViewItem(title: "Drawing") {
                        DrawingView()
                    }
                    MainContentViewItem(title: "Weather") {
                        SampleWeatherView()
                    }
                }
            }
        }
        .navigationTitle(title)
    }
}

struct MainContentViewItem<Content: View>: View {
    @State var title: String
    @ViewBuilder var content: () -> Content
    var body: some View {
        NavigationLink {
            content()
        } label: {
            Text(title)
        }
    }
}

struct BasicNavigationView: View {
    @State var title: String
    
    var body: some View {
        List {
            MainContentViewItem(title: "Swift UI 主题色") {
                SampleTintColor()
            }
            MainContentViewItem(title: "Swift UI 生命周期") {
                SampleSceneLifeCycle()
            }
            MainContentViewItem(title: "TabView") {
                SampleTabView()
            }
            Group{
                MainContentViewItem(title: "Navigation（系统自动管理导航状态）") {
                    SampleBasicNavigationStack()
                }
                MainContentViewItem(title: "Navigation（手动管理导航状态）") {
                    SampleAdvancedNavigationStack()
                }
                MainContentViewItem(title: "Navigation（导航状态的保存与退出）") {
                    SampleNavigationStackRestore()
                }
                MainContentViewItem(title: "NavigationSplitView（多栏视图）") {
                    SampleNavigationSplitView()
                }
            }
            MainContentViewItem(title: "模态（Sheet、Alert、Dialog）") {
                SampleModal()
            }
            MainContentViewItem(title: "工具栏") {
                SampleToolbars()
            }
            Group{
                MainContentViewItem(title: "视图管理（Identity）") {
                    SampleViewIdentity()
                }
                MainContentViewItem(title: "视图管理（生命周期）") {
                    SampleViewsLife()
                }
                MainContentViewItem(title: "视图管理（更新与优化）") {
                    SampleViewOptimize()
                }
            }
            MainContentViewItem(title: "SwiftUI 的属性包装器") {
                SamplePropertyWrappers()
            }
        }
    }
}

struct BasicViewNavigationView: View {
    @State var title: String
    
    var body: some View {
        List {
            Section("基础视图"){
                Group{
                    MainContentViewItem(title: "文本 - Text") {
                        SampleText()
                    }
                    MainContentViewItem(title: "文本 - Label") {
                        SampleLabel()
                    }
                    MainContentViewItem(title: "输入 - TextField") {
                        SampleTextField()
                    }
                    MainContentViewItem(title: "输入 - TextEditor") {
                        SampleTextEditor()
                    }
                    MainContentViewItem(title: "按钮 - Button") {
                        SampleButton()
                    }
                    MainContentViewItem(title: "链接 - Link") {
                        SampleLink()
                    }
                    MainContentViewItem(title: "菜单 - Menu") {
                        SampleMenuAndCommands()
                    }
                }
                Group{
                    MainContentViewItem(title: "图片 - 资源图片") {
                        SampleLocalImage()
                    }
                    MainContentViewItem(title: "图片 - SF Symbols") {
                        SampleSFSymbolsImage()
                    }
                    MainContentViewItem(title: "图片 - 网络图片") {
                        SampleAsyncImage()
                    }
                    MainContentViewItem(title: "图片 - 生成图片") {
                        SampleImageRenderer()
                    }
                }
                Group{
                    MainContentViewItem(title: "选择器 - Toggle") {
                        SampleToggle()
                    }
                    MainContentViewItem(title: "选择器 - Slider") {
                        SampleSlider()
                    }
                    MainContentViewItem(title: "选择器 - Stepper") {
                        SampleStepper()
                    }
                    MainContentViewItem(title: "选择器 - Picker") {
                        SamplePicker()
                    }
                    MainContentViewItem(title: "选择器 - DatePicker") {
                        SampleDatePicker()
                    }
                    MainContentViewItem(title: "选择器 - MultiDatePicker") {
                        SampleMultiDatePicker()
                    }
                    MainContentViewItem(title: "选择器 - ColorPicker") {
                        SampleColorPicker()
                    }
                }
                Group{
                    MainContentViewItem(title: "指示器 - ProgressView") {
                        SampleProgressView()
                    }
                    MainContentViewItem(title: "指示器 - Gauge") {
                        SampleGauge()
                    }
                }
            }
            Section("视图样式与行为"){
                Group{
                    MainContentViewItem(title: "字体") {
                        SampleFonts()
                    }
                    MainContentViewItem(title: "颜色") {
                        SampleColor()
                    }
                    MainContentViewItem(title: "外观") {
                        SamplePreferredColorScheme()
                    }
                    MainContentViewItem(title: "阴影") {
                        SampleShadow()
                    }
                    MainContentViewItem(title: "模糊") {
                        SampleBlur()
                    }
                    MainContentViewItem(title: "显示与隐藏") {
                        SampleViewHidden()
                    }
                    MainContentViewItem(title: "可交互性") {
                        SampleViewInteraction()
                    }
                }
            }
            Section("控件样式"){
                MainContentViewItem(title: "色调、显示与隐藏、尺寸") {
                    SampleControlStyle()
                }
            }
            Section("视图 - 其他"){
                MainContentViewItem(title: "视图生命周期方法") {
                    SampleViewLifeCycle()
                }
                MainContentViewItem(title: "自定义视图") {
                    SampleCustomView()
                }
                MainContentViewItem(title: "使用 UIKit") {
                    SampleBridgingUIKit()
                }
            }
        }
    }
}

struct PanelViewNavigationView: View {
    @State var title: String
    
    var body: some View {
        List {
            Group{
                MainContentViewItem(title: "堆叠（HStack、LazyHStack、LazyVStack）") {
                    SampleStacks()
                }
                MainContentViewItem(title: "视图组（Group、GroupBox、Section、Form）") {
                    SampleViewGroupings()
                }
                MainContentViewItem(title: "格子（Grids）") {
                    SampleGrids()
                }
                MainContentViewItem(title: "滑动视图（ScrollView）") {
                    SampleScrollView()
                }
                MainContentViewItem(title: "列表（List）") {
                    SampleList()
                }
            }
        }
    }
}

struct ViewLayoutNavigationView: View {
    @State var title: String
    
    var body: some View {
        List {
            Group{
                MainContentViewItem(title: "布局 - 尺寸（Padding、frame、fixedSize、layoutPriority）") {
                    SampleLayoutSize()
                }
                MainContentViewItem(title: "布局 - 位置（Spacer、Divider、Position、Offset）") {
                    SampleLayoutPosition()
                }
                MainContentViewItem(title: "布局 - 对齐方式(Alignment)") {
                    SampleLayoutAlignment()
                }
                MainContentViewItem(title: "布局 - 安全区域（SafeArea）") {
                    SampleLayoutSafeArea()
                }
                MainContentViewItem(title: "布局 - 自适应") {
                    SampleLayoutFits()
                }
            }
            Group{
                MainContentViewItem(title: "共享布局信息") {
                    SampleLayoutSharing()
                }
                MainContentViewItem(title: "自定义布局") {
                    SampleCustomLayout()
                }
            }
        }
    }
}

struct ShapeViewNavigationView: View {
    @State var title: String
    
    var body: some View {
        List {
            MainContentViewItem(title: "形状 - 内置形状") {
                SampleBuiltInShapes()
            }
            MainContentViewItem(title: "形状 - 样式与行为") {
                SampleShapesStyle()
            }
            MainContentViewItem(title: "形状 - Path 自定义形状") {
                SamplePath()
            }
            MainContentViewItem(title: "图形 - Canvas") {
                SampleDrawing()
            }
            MainContentViewItem(title: "图表 - Charts") {
                SampleCharts()
            }
        }
    }
}

struct AnimationViewNavigationView: View {
    @State var title: String
    
    var body: some View {
        List {
            MainContentViewItem(title: "基础动画") {
                SampleBasicAnimation()
            }
            MainContentViewItem(title: "转场动画") {
                SampleTransitions()
            }
            MainContentViewItem(title: "转场动画") {
                SampleTransitions()
            }
            MainContentViewItem(title: "Animatable 协议") {
                SampleAnimatable()
            }
            MainContentViewItem(title: "动画进阶") {
                SampleAdvancedAnimation()
            }
        }
    }
}

struct GestureViewNavigationView: View {
    @State var title: String
    
    var body: some View {
        List {
            MainContentViewItem(title: "常见手势") {
                SampleBasicGestures()
            }
            MainContentViewItem(title: "限定手势范围") {
                SampleGesturesHandling()
            }
            MainContentViewItem(title: "手势组合") {
                SampleGesturesComposing()
            }
            MainContentViewItem(title: "自定义手势") {
                SampleCustomGestures()
            }
        }
    }
}

struct MainNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigationView(title: "test")
            .previewInterfaceOrientation(.portrait)
    }
}
