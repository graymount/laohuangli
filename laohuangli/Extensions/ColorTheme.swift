import SwiftUI

extension Color {
    // MARK: - 自适应颜色系统 (支持暗黑模式)
    static let appPrimaryBackground = Color.adaptive(
        light: Color(red: 0.98, green: 0.96, blue: 0.92),
        dark: Color(red: 0.1, green: 0.1, blue: 0.1)
    )
    static let appCardBackground = Color.adaptive(
        light: Color.white,
        dark: Color(red: 0.15, green: 0.15, blue: 0.15)
    )
    static let appSecondaryBackground = Color.adaptive(
        light: Color(red: 0.96, green: 0.94, blue: 0.89),
        dark: Color(red: 0.12, green: 0.12, blue: 0.12)
    )
    
    // MARK: - 文字颜色 (自适应)
    static let primaryText = Color.adaptive(
        light: Color.black,
        dark: Color.white
    )
    static let secondaryText = Color.adaptive(
        light: Color.gray,
        dark: Color(red: 0.8, green: 0.8, blue: 0.8)
    )
    static let mutedText = Color.adaptive(
        light: Color(red: 0.6, green: 0.6, blue: 0.6),
        dark: Color(red: 0.5, green: 0.5, blue: 0.5)
    )
    
    // MARK: - 主题色彩 (保持一致)
    static let auspiciousRed = Color(red: 0.85, green: 0.2, blue: 0.2)
    static let festiveAccent = Color(red: 0.95, green: 0.85, blue: 0.85)
    static let successGreen = Color(red: 0.2, green: 0.7, blue: 0.4)
    static let warningOrange = Color(red: 0.95, green: 0.6, blue: 0.1)
    static let infoBlue = Color(red: 0.2, green: 0.5, blue: 0.9)
    
    // MARK: - 阴影颜色 (自适应)
    static let cardShadow = Color.adaptive(
        light: Color.black.opacity(0.1),
        dark: Color.clear
    )
    static let primaryShadow = Color.adaptive(
        light: Color.black.opacity(0.05),
        dark: Color.clear
    )
    
    // MARK: - 渐变色彩 (保持传统特色)
    static let heroGradient = LinearGradient(
        colors: [auspiciousRed, Color(red: 0.92, green: 0.26, blue: 0.21)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let homeBackgroundGradient: LinearGradient = LinearGradient(
        colors: [appPrimaryBackground, appSecondaryBackground],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let cardBackgroundGradient: LinearGradient = LinearGradient(
        colors: [appCardBackground, appCardBackground.opacity(0.95)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let festiveRedGradient = LinearGradient(
        colors: [auspiciousRed, Color(red: 0.7, green: 0.15, blue: 0.15)],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let luckyRedGradient = LinearGradient(
        colors: [Color(red: 0.9, green: 0.3, blue: 0.3), auspiciousRed],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let goldenGradient = LinearGradient(
        colors: [Color(red: 1.0, green: 0.84, blue: 0.0), Color(red: 0.85, green: 0.65, blue: 0.13)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let celebrationGradient = LinearGradient(
        colors: [Color(red: 0.85, green: 0.2, blue: 0.5), Color(red: 0.6, green: 0.15, blue: 0.4)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let jadeGradient = LinearGradient(
        colors: [Color(red: 0.0, green: 0.7, blue: 0.4), Color(red: 0.0, green: 0.5, blue: 0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let darkRedBorder = Color(red: 0.6, green: 0.1, blue: 0.1)
}

// MARK: - 暗黑模式适配扩展
extension Color {
    /// 创建自适应颜色
    static func adaptive(light: Color, dark: Color) -> Color {
        return Color(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
    
    /// 主要背景色 - 自适应
    static let adaptivePrimaryBackground = adaptive(
        light: Color(red: 0.98, green: 0.96, blue: 0.92),
        dark: Color(red: 0.1, green: 0.1, blue: 0.1)
    )
    
    /// 卡片背景色 - 自适应
    static let adaptiveCardBackground = adaptive(
        light: Color.white,
        dark: Color(red: 0.15, green: 0.15, blue: 0.15)
    )
    
    /// 主要文字颜色 - 自适应
    static let adaptivePrimaryText = adaptive(
        light: Color.black,
        dark: Color.white
    )
    
    /// 次要文字颜色 - 自适应
    static let adaptiveSecondaryText = adaptive(
        light: Color.gray,
        dark: Color(red: 0.8, green: 0.8, blue: 0.8)
    )
    
    /// 卡片阴影 - 自适应
    static let adaptiveCardShadow = adaptive(
        light: Color.black.opacity(0.1),
        dark: Color.clear
    )
}

// MARK: - 传统色彩保留（向后兼容）
extension Color {
    static let oldPaper = Color(red: 0.96, green: 0.92, blue: 0.84)
    static let antiqueWhite = Color(red: 0.98, green: 0.94, blue: 0.87)
    static let parchment = Color(red: 0.94, green: 0.89, blue: 0.79)
    static let vintageBeige = Color(red: 0.93, green: 0.88, blue: 0.76)
    static let agedYellow = Color(red: 0.95, green: 0.90, blue: 0.75)
    
    // 重命名的特色颜色 (避免与资产目录冲突)
    static let customRoyalBlue = Color(red: 0.25, green: 0.41, blue: 0.88)
    static let customSoftPurple = Color(red: 0.68, green: 0.51, blue: 0.89)
    static let customGoldenYellow = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let customJadeGreen = Color(red: 0.0, green: 0.66, blue: 0.42)
    
    // 功能色彩
    static let fortuneColors: [Color] = [
        .auspiciousRed, .customGoldenYellow, .customJadeGreen, .customRoyalBlue, .customSoftPurple
    ]
    
    static func randomFortuneColor() -> Color {
        return fortuneColors.randomElement() ?? .auspiciousRed
    }
}

// MARK: - 便捷属性别名
extension Color {
    static var primaryBackground: Color { appPrimaryBackground }
    static var cardBackground: Color { appCardBackground }
    static var secondaryBackground: Color { appSecondaryBackground }
    static var borderGray: Color { Color(red: 0.9, green: 0.9, blue: 0.9) }
} 