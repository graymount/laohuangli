import SwiftUI

// 1. 定义标签页的标识符
enum TabIdentifier: Hashable {
    case today
    case fortune
    case auspiciousDays
    case settings
}

// 2. 创建共享状态对象
class TabRouter: ObservableObject {
    @Published var currentTab: TabIdentifier = .today // 默认选中"今日"
    
    func changeTab(to tab: TabIdentifier) {
        currentTab = tab
    }
} 