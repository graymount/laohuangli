import SwiftUI

extension Color {
    // MARK: - 旧纸张风格色彩
    static let oldPaper = Color(red: 0.96, green: 0.92, blue: 0.84) // 旧纸张色
    static let antiqueWhite = Color(red: 0.98, green: 0.94, blue: 0.87) // 古白色
    static let parchment = Color(red: 0.94, green: 0.89, blue: 0.79) // 羊皮纸色
    static let vintageBeige = Color(red: 0.93, green: 0.88, blue: 0.76) // 复古米色
    static let agedYellow = Color(red: 0.95, green: 0.90, blue: 0.75) // 陈年黄
    
    // MARK: - 渐变色组合
    static let chineseRedGradient = LinearGradient(
        gradient: Gradient(colors: [.primaryRed, .primaryRed.opacity(0.7)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let goldenGradient = LinearGradient(
        gradient: Gradient(colors: [.goldenYellow, .warmOrange]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let jadeGradient = LinearGradient(
        gradient: Gradient(colors: [.jadeGreen, .jadeGreen.opacity(0.6)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let royalGradient = LinearGradient(
        gradient: Gradient(colors: [.royalBlue, .softPurple]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let sunsetGradient = LinearGradient(
        gradient: Gradient(colors: [.warmOrange, .goldenYellow, .primaryRed.opacity(0.8)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - 新增喜庆红色渐变
    static let festiveRedGradient = LinearGradient(
        gradient: Gradient(colors: [.primaryRed, .warmOrange.opacity(0.8)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let luckyRedGradient = LinearGradient(
        gradient: Gradient(colors: [.primaryRed.opacity(0.9), .goldenYellow.opacity(0.6), .primaryRed]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let celebrationGradient = LinearGradient(
        gradient: Gradient(colors: [.primaryRed, .primaryRed.opacity(0.8), .goldenYellow.opacity(0.7)]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    // MARK: - 旧纸张风格背景渐变
    static let homeBackgroundGradient = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: .antiqueWhite, location: 0.0),
            .init(color: .oldPaper, location: 0.3),
            .init(color: .parchment, location: 0.6),
            .init(color: .vintageBeige, location: 0.8),
            .init(color: .agedYellow, location: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // 旧报纸风格卡片背景
    static let cardBackgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            .oldPaper,
            .parchment,
            .vintageBeige.opacity(0.9)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // 暗红色边框
    static let darkRedBorder = Color(red: 0.6, green: 0.15, blue: 0.15) // 暗红色边框
    static let paperTexture = Color(red: 0.95, green: 0.91, blue: 0.82) // 纸张纹理色
    
    // MARK: - 功能色彩（红色优先）
    static let fortuneColors: [Color] = [.primaryRed, .primaryRed, .goldenYellow, .jadeGreen, .royalBlue, .softPurple]
    
    static func randomFortuneColor() -> Color {
        return fortuneColors.randomElement() ?? .primaryRed
    }
    
    // MARK: - 阴影色彩（适配纸张背景）
    static let cardShadow = Color.black.opacity(0.08)
    static let accentShadow = Color.primaryRed.opacity(0.3)
    
    // MARK: - 喜庆装饰色彩
    static let auspiciousRed = Color.primaryRed.opacity(0.9)
    static let festiveAccent = Color.primaryRed.opacity(0.15)
    static let luckyBorder = Color.primaryRed.opacity(0.6)
} 