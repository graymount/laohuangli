//
//  ContentView.swift
//  laohuangli
//
//  Created by liuwnfng on 2025/5/28.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var tabRouter: TabRouter // 访问 TabRouter
    @StateObject private var calendarService = CalendarService.shared
    @StateObject private var userService = UserService.shared
    // selectedTab 现在由 tabRouter.currentTab 控制
    
    var body: some View {
        TabView(selection: $tabRouter.currentTab) { // 绑定到 tabRouter.currentTab
            HomeView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("今日")
                }
                .tag(TabIdentifier.today) // 使用枚举作为标签
            
            FortuneView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("运势")
                }
                .tag(TabIdentifier.fortune)
            
            AuspiciousDaysView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("吉日")
                }
                .tag(TabIdentifier.auspiciousDays)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("设置")
                }
                .tag(TabIdentifier.settings)
        }
        .background(Color.homeBackgroundGradient.ignoresSafeArea())
        // 移除手动滑动手势，因为它可能会与 TabView 的原生滑动冲突，并且状态管理现在由 TabRouter 统一处理
        // .gesture(...)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.94, green: 0.89, blue: 0.79, alpha: 1.0) // parchment色
        
        // 设置选中状态的颜色
        // Modern TabView styling does not use selectionIndicatorTintColor directly on UITabBarAppearance for item tint.
        // Instead, we will rely on accentColor or .tint() modifier on the TabView or individual views.
        // For now, let's ensure the item tint is handled correctly by SwiftUI by default or via .accentColor.

        let itemAppearance = UITabBarItemAppearance()
        // Set unselected state color
        itemAppearance.normal.iconColor = UIColor.gray
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
        
        // Set selected state color
        let selectedColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0) // auspiciousRed
        itemAppearance.selected.iconColor = selectedColor
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]
        
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    ContentView()
        .environmentObject(TabRouter()) // 为预览添加 TabRouter
}
