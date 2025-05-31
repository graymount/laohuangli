// AppConfig.swift

import Foundation

struct AppConfig {
    // App Store ID (应用上架后由 App Store Connect 提供)
    // 在应用获得 App Store ID 后，请将此值更新为您的实际 App Store ID
    static let appStoreID: String? = nil
    
    // 应用基本信息
    static let appName = "老黄历"
    static let appVersion = "1.0.0"
    static let minimumIOSVersion = "15.0"
    
    // 联系信息
    static let supportEmail = "support@laohuangli.app"
    static let privacyEmail = "privacy@laohuangli.app"
    static let feedbackEmail = "feedback@laohuangli.app"
    
    // 应用链接
    static let appStoreURL: String? = {
        guard let appID = appStoreID else { return nil }
        return "https://apps.apple.com/app/id\(appID)"
    }()
    
    // 检查应用是否已上架
    static var isAppStoreReleased: Bool {
        return appStoreID != nil && !appStoreID!.isEmpty
    }
} 