//
//  ContentView.swift
//  laohuangli
//
//  Created by liuwnfng on 2025/5/28.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var calendarService = CalendarService.shared
    @StateObject private var userService = UserService.shared
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 主页 - 今日黄历
            HomeView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("今日")
                }
                .tag(0)
            
            // 运势分析
            FortuneView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("运势")
                }
                .tag(1)
            
            // 吉日查询
            AuspiciousDaysView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("吉日")
                }
                .tag(2)
            
            // 设置
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("设置")
                }
                .tag(3)
        }
        .background(Color.homeBackgroundGradient.ignoresSafeArea())
        .gesture(
            DragGesture()
                .onEnded { value in
                    let threshold: CGFloat = 50
                    if value.translation.width > threshold && selectedTab > 0 {
                        // 向右滑动，切换到上一个标签
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab -= 1
                        }
                    } else if value.translation.width < -threshold && selectedTab < 3 {
                        // 向左滑动，切换到下一个标签
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab += 1
                        }
                    }
                }
        )
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.94, green: 0.89, blue: 0.79, alpha: 1.0) // parchment色
        
        // 设置选中状态的颜色
        appearance.selectionIndicatorTintColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    ContentView()
}
