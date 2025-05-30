import Foundation
import SwiftUI

class UserService: ObservableObject {
    static let shared = UserService()
    
    @Published var userProfile: UserProfile?
    @Published var notificationSettings = NotificationSettings()
    
    private let userDefaults = UserDefaults.standard
    private let userProfileKey = "UserProfile"
    private let notificationSettingsKey = "NotificationSettings"
    
    private init() {
        loadUserData()
    }
    
    // MARK: - 用户资料管理
    func saveUserProfile(_ profile: UserProfile) {
        self.userProfile = profile
        
        if let encoded = try? JSONEncoder().encode(profile) {
            userDefaults.set(encoded, forKey: userProfileKey)
        }
    }
    
    func getUserProfile() -> UserProfile? {
        return userProfile
    }
    
    // MARK: - 通知设置
    func updateNotificationSettings(_ settings: NotificationSettings) {
        self.notificationSettings = settings
        saveNotificationSettings()
    }
    
    private func saveNotificationSettings() {
        if let encoded = try? JSONEncoder().encode(notificationSettings) {
            userDefaults.set(encoded, forKey: notificationSettingsKey)
        }
    }
    
    // MARK: - 数据加载
    private func loadUserData() {
        loadUserProfile()
        loadNotificationSettings()
    }
    
    private func loadUserProfile() {
        if let data = userDefaults.data(forKey: userProfileKey),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
            userProfile = decoded
        }
    }
    
    private func loadNotificationSettings() {
        if let data = userDefaults.data(forKey: notificationSettingsKey),
           let decoded = try? JSONDecoder().decode(NotificationSettings.self, from: data) {
            notificationSettings = decoded
        }
    }
    
    // MARK: - 星座和生肖计算
    func calculateZodiacSign(from birthday: Date) -> ZodiacSign {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: birthday)
        let day = calendar.component(.day, from: birthday)
        
        switch (month, day) {
        case (3, 21...31), (4, 1...19): return .aries
        case (4, 20...30), (5, 1...20): return .taurus
        case (5, 21...31), (6, 1...20): return .gemini
        case (6, 21...30), (7, 1...22): return .cancer
        case (7, 23...31), (8, 1...22): return .leo
        case (8, 23...31), (9, 1...22): return .virgo
        case (9, 23...30), (10, 1...22): return .libra
        case (10, 23...31), (11, 1...21): return .scorpio
        case (11, 22...30), (12, 1...21): return .sagittarius
        case (12, 22...31), (1, 1...19): return .capricorn
        case (1, 20...31), (2, 1...18): return .aquarius
        case (2, 19...29), (3, 1...20): return .pisces
        default: return .aries
        }
    }
    
    func calculateChineseZodiac(from birthday: Date) -> ChineseZodiac {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: birthday)
        let zodiacs = ChineseZodiac.allCases
        return zodiacs[(year - 4) % 12]
    }
}

// MARK: - 通知设置模型
struct NotificationSettings: Codable {
    var isEnabled: Bool = false
    var hour: Int = 8
    var minute: Int = 0
    var includeFortune: Bool = true
    var includeAdvice: Bool = true
    var includeFestivals: Bool = true
}
