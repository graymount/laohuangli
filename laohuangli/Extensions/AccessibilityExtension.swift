import SwiftUI

// MARK: - 无障碍支持扩展
extension View {
    /// 为日历组件添加无障碍支持
    func calendarAccessibility(date: Date, isSelected: Bool, isToday: Bool, calendarInfo: CalendarDate?) -> some View {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M月d日"
        let dateString = dateFormatter.string(from: date)
        
        var accessibilityLabel = ""
        var accessibilityHint = ""
        var accessibilityTraits: AccessibilityTraits = []
        
        // 构建标签
        if isToday {
            accessibilityLabel = "今天，\(dateString)"
            accessibilityTraits = accessibilityTraits.union(.startsMediaSession)
        } else {
            accessibilityLabel = dateString
        }
        
        if isSelected {
            accessibilityLabel += "，已选中"
            accessibilityTraits = accessibilityTraits.union(.isSelected)
        }
        
        // 添加农历信息
        if let calendarInfo = calendarInfo {
            accessibilityLabel += "，农历\(calendarInfo.lunarDate.month)\(calendarInfo.lunarDate.day)"
            
            // 添加节日或节气信息
            if let festival = calendarInfo.festival {
                accessibilityLabel += "，\(festival)"
            } else if let solarTerm = calendarInfo.solarTerm {
                accessibilityLabel += "，\(solarTerm)"
            }
        }
        
        // 提示信息
        accessibilityHint = "双击选择此日期，查看详细信息"
        
        return self
            .accessibilityLabel(accessibilityLabel)
            .accessibilityHint(accessibilityHint)
            .accessibilityAddTraits(accessibilityTraits)
            .accessibilityAddTraits(.isButton)
    }
    
    /// 为宜忌建议添加无障碍支持
    func adviceAccessibility(advice: DailyAdvice) -> some View {
        let suitableText = "宜：" + advice.suitable.prefix(3).joined(separator: "，")
        let unsuitableText = "忌：" + advice.unsuitable.prefix(3).joined(separator: "，")
        let fullText = suitableText + "。" + unsuitableText
        
        return self
            .accessibilityLabel("今日宜忌建议")
            .accessibilityValue(fullText)
            .accessibilityHint("双击查看完整的宜忌详情")
            .accessibilityAddTraits(.isButton)
    }
    
    /// 为运势信息添加无障碍支持
    func fortuneAccessibility(fortune: FortuneLevel) -> some View {
        let fortuneText: String
        
        switch fortune {
        case .excellent:
            fortuneText = "极佳"
        case .good:
            fortuneText = "良好"
        case .average:
            fortuneText = "一般"
        case .poor:
            fortuneText = "较差"
        case .terrible:
            fortuneText = "极差"
        @unknown default:
            fortuneText = "未知"
        }
        
        return self
            .accessibilityLabel("运势等级")
            .accessibilityValue(fortuneText)
    }
    
    /// 为设置项添加无障碍支持
    func settingAccessibility(title: String, subtitle: String, hasNavigation: Bool = false) -> some View {
        let accessibilityLabel = title
        let accessibilityValue = subtitle
        let accessibilityHint = hasNavigation ? "双击进入设置页面" : "双击执行操作"
        
        var traits: AccessibilityTraits = [.isButton]
        if hasNavigation {
            traits = traits.union(.causesPageTurn)
        }
        
        return self
            .accessibilityLabel(accessibilityLabel)
            .accessibilityValue(accessibilityValue)
            .accessibilityHint(accessibilityHint)
            .accessibilityAddTraits(traits)
    }
    
    /// 为切换开关添加无障碍支持
    func toggleAccessibility(title: String, isOn: Bool, description: String? = nil) -> some View {
        let state = isOn ? "开启" : "关闭"
        let accessibilityLabel = title
        let accessibilityValue = "当前状态：\(state)"
        let accessibilityHint = "双击\(isOn ? "关闭" : "开启")\(title)"
        
        var fullLabel = accessibilityLabel
        if let description = description {
            fullLabel += "，\(description)"
        }
        
        return self
            .accessibilityLabel(fullLabel)
            .accessibilityValue(accessibilityValue)
            .accessibilityHint(accessibilityHint)
            .accessibilityAddTraits(.isToggle)
    }
    
    /// 为导航标签添加无障碍支持
    func tabAccessibility(title: String, isSelected: Bool) -> some View {
        let accessibilityLabel = title + "标签"
        let accessibilityValue = isSelected ? "已选中" : "未选中"
        let accessibilityHint = "双击切换到\(title)页面"
        
        var traits: AccessibilityTraits = [.isButton]
        if isSelected {
            traits = traits.union(.isSelected)
        }
        
        return self
            .accessibilityLabel(accessibilityLabel)
            .accessibilityValue(accessibilityValue)
            .accessibilityHint(accessibilityHint)
            .accessibilityAddTraits(traits)
    }
    
    /// 为分享按钮添加无障碍支持
    func shareAccessibility(content: String) -> some View {
        return self
            .accessibilityLabel("分享")
            .accessibilityHint("双击分享\(content)")
            .accessibilityAddTraits(.isButton)
    }
    
    /// 为通知时间选择器添加无障碍支持
    func timePickerAccessibility(hour: Int, minute: Int) -> some View {
        let timeString = String(format: "%d时%d分", hour, minute)
        
        return self
            .accessibilityLabel("提醒时间")
            .accessibilityValue(timeString)
            .accessibilityHint("使用滑动手势调整时间")
    }
}

// MARK: - Dynamic Type支持
extension Font {
    /// 根据用户偏好动态调整字体大小
    static func dynamicTitle() -> Font {
        return .system(.title, design: .default).weight(.bold)
    }
    
    static func dynamicHeadline() -> Font {
        return .system(.headline, design: .default).weight(.semibold)
    }
    
    static func dynamicBody() -> Font {
        return .system(.body, design: .default)
    }
    
    static func dynamicCaption() -> Font {
        return .system(.caption, design: .default)
    }
    
    static func dynamicSubheadline() -> Font {
        return .system(.subheadline, design: .default)
    }
}

// MARK: - 高对比度支持
extension Color {
    /// 根据系统设置提供高对比度颜色
    static func dynamicForeground() -> Color {
        return Color.primary
    }
    
    static func dynamicBackground() -> Color {
        return Color(.systemBackground)
    }
    
    static func dynamicSecondaryBackground() -> Color {
        return Color(.secondarySystemBackground)
    }
    
    static func dynamicAccent() -> Color {
        return Color.accentColor
    }
}

// MARK: - 语音控制支持
extension View {
    /// 为语音控制添加自定义标识符
    func voiceControlIdentifier(_ identifier: String) -> some View {
        return self.accessibilityIdentifier(identifier)
    }
    
    /// 为常用操作添加语音控制支持
    func addVoiceControlSupport(action: String, target: String) -> some View {
        return self
            .accessibilityLabel("\(action)\(target)")
            .accessibilityIdentifier("\(action)_\(target)")
    }
}

// MARK: - 减少动画支持
extension View {
    /// 根据用户设置减少动画
    func respectReduceMotion<T: View>(@ViewBuilder animation: () -> T, @ViewBuilder staticView: () -> T) -> some View {
        let reduceMotion = UIAccessibility.isReduceMotionEnabled
        
        return Group {
            if reduceMotion {
                staticView()
            } else {
                animation()
            }
        }
    }
    
    /// 可访问的动画修饰符
    func accessibleAnimation(_ animation: Animation? = .default) -> some View {
        return self.animation(UIAccessibility.isReduceMotionEnabled ? nil : animation, value: UUID())
    }
}

// MARK: - 无障碍工具方法
struct AccessibilityHelper {
    /// 格式化日期为无障碍友好的文本
    static func formatDateForAccessibility(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    /// 格式化时间为无障碍友好的文本
    static func formatTimeForAccessibility(hour: Int, minute: Int) -> String {
        if minute == 0 {
            return "\(hour)点整"
        } else {
            return "\(hour)点\(minute)分"
        }
    }
    
    /// 检查是否启用了无障碍功能
    static var isAccessibilityEnabled: Bool {
        return UIAccessibility.isVoiceOverRunning || 
               UIAccessibility.isSwitchControlRunning || 
               UIAccessibility.isAssistiveTouchRunning
    }
    
    /// 提供无障碍公告
    static func announceAccessibility(_ message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIAccessibility.post(notification: .announcement, argument: message)
        }
    }
}

// MARK: - 自定义无障碍组件
struct AccessibleButton<Content: View>: View {
    let action: () -> Void
    let content: Content
    let accessibilityLabel: String
    let accessibilityHint: String?
    
    init(
        accessibilityLabel: String,
        accessibilityHint: String? = nil,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        Button(action: action) {
            content
        }
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint ?? "")
        .accessibilityAddTraits(.isButton)
    }
} 