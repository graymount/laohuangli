import UserNotifications
import Foundation

// MARK: - 通知服务
class NotificationService: ObservableObject {
    static let shared = NotificationService()
    
    @Published var isAuthorized = false
    @Published var dailyReminderEnabled = false
    @Published var reminderTime = DateComponents(hour: 8, minute: 0) // 默认早上8点
    
    private init() {
        checkAuthorizationStatus()
        loadUserSettings()
    }
    
    // MARK: - 权限管理
    func requestAuthorization() async -> Bool {
        let center = UNUserNotificationCenter.current()
        
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            await MainActor.run {
                self.isAuthorized = granted
            }
            return granted
        } catch {
            print("通知权限请求失败: \(error)")
            return false
        }
    }
    
    private func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    // MARK: - 每日提醒设置
    func enableDailyReminder(_ enabled: Bool) {
        dailyReminderEnabled = enabled
        saveUserSettings()
        
        if enabled {
            scheduleDailyReminder()
        } else {
            removeDailyReminder()
        }
    }
    
    func setReminderTime(hour: Int, minute: Int) {
        reminderTime = DateComponents(hour: hour, minute: minute)
        saveUserSettings()
        
        if dailyReminderEnabled {
            scheduleDailyReminder()
        }
    }
    
    private func scheduleDailyReminder() {
        // 移除旧的通知
        removeDailyReminder()
        
        guard isAuthorized else { return }
        
        let center = UNUserNotificationCenter.current()
        
        // 创建通知内容
        let content = UNMutableNotificationContent()
        content.title = "今日黄历提醒"
        content.body = generateRandomReminderMessage()
        content.sound = .default
        content.badge = 1
        
        // 创建每日触发器
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: reminderTime,
            repeats: true
        )
        
        // 创建通知请求
        let request = UNNotificationRequest(
            identifier: "daily_calendar_reminder",
            content: content,
            trigger: trigger
        )
        
        // 添加通知
        center.add(request) { error in
            if let error = error {
                print("添加每日提醒失败: \(error)")
            } else {
                print("每日提醒设置成功")
            }
        }
    }
    
    private func removeDailyReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["daily_calendar_reminder"]
        )
    }
    
    // MARK: - 特殊节日提醒
    func scheduleSpecialFestivalReminders() {
        guard isAuthorized else { return }
        
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        let specialDates = [
            (month: 2, day: 14, name: "情人节"),
            (month: 3, day: 8, name: "妇女节"),
            (month: 5, day: 1, name: "劳动节"),
            (month: 6, day: 1, name: "儿童节"),
            (month: 10, day: 1, name: "国庆节"),
            (month: 12, day: 25, name: "圣诞节")
        ]
        
        for specialDate in specialDates {
            if let date = calendar.date(from: DateComponents(
                year: currentYear,
                month: specialDate.month,
                day: specialDate.day
            )) {
                scheduleSpecialDateReminder(date: date, festivalName: specialDate.name)
            }
        }
    }
    
    private func scheduleSpecialDateReminder(date: Date, festivalName: String) {
        let calendar = Calendar.current
        let reminderDate = calendar.date(byAdding: .day, value: -1, to: date) // 提前一天提醒
        
        guard let reminderDate = reminderDate, reminderDate > Date() else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "节日提醒"
        content.body = "明天是\(festivalName)，记得查看黄历宜忌安排！"
        content.sound = .default
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "festival_\(festivalName)_\(calendar.component(.year, from: date))",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - 节气提醒
    func scheduleSolarTermReminders() {
        guard isAuthorized else { return }
        
        let solarTerms = [
            "立春", "雨水", "惊蛰", "春分", "清明", "谷雨",
            "立夏", "小满", "芒种", "夏至", "小暑", "大暑",
            "立秋", "处暑", "白露", "秋分", "寒露", "霜降",
            "立冬", "小雪", "大雪", "冬至", "小寒", "大寒"
        ]
        
        // 这里应该根据实际的节气日期计算
        // 为简化示例，这里仅展示框架
        for (index, term) in solarTerms.enumerated() {
            // 实际实现中需要精确计算节气时间
            scheduleSolarTermReminder(termName: term, sequence: index)
        }
    }
    
    private func scheduleSolarTermReminder(termName: String, sequence: Int) {
        let content = UNMutableNotificationContent()
        content.title = "节气提醒"
        content.body = "今日\(termName)，查看传统习俗和养生建议！"
        content.sound = .default
        
        // 这里需要实际的节气日期计算
        // 暂时使用示例逻辑
    }
    
    // MARK: - 提醒消息生成
    private func generateRandomReminderMessage() -> String {
        let messages = [
            "查看今日宜忌，合理安排一天行程",
            "新的一天开始了，让传统智慧指引您",
            "今日运势如何？快来查看黄历吧",
            "传统文化伴您度过美好一天",
            "宜忌有度，生活有序",
            "古人智慧，现代生活的指南针"
        ]
        
        return messages.randomElement() ?? "查看今日黄历宜忌"
    }
    
    // MARK: - 设置持久化
    private func saveUserSettings() {
        UserDefaults.standard.set(dailyReminderEnabled, forKey: "daily_reminder_enabled")
        UserDefaults.standard.set(reminderTime.hour ?? 8, forKey: "reminder_hour")
        UserDefaults.standard.set(reminderTime.minute ?? 0, forKey: "reminder_minute")
    }
    
    private func loadUserSettings() {
        dailyReminderEnabled = UserDefaults.standard.bool(forKey: "daily_reminder_enabled")
        let hour = UserDefaults.standard.integer(forKey: "reminder_hour")
        let minute = UserDefaults.standard.integer(forKey: "reminder_minute")
        reminderTime = DateComponents(hour: hour == 0 ? 8 : hour, minute: minute)
    }
    
    // MARK: - 通知处理
    func handleNotificationResponse(_ response: UNNotificationResponse) {
        let identifier = response.notification.request.identifier
        
        switch identifier {
        case "daily_calendar_reminder":
            // 处理每日提醒点击
            NotificationCenter.default.post(name: .openTodayCalendar, object: nil)
            
        case let id where id.starts(with: "festival_"):
            // 处理节日提醒点击
            NotificationCenter.default.post(name: .openFestivalInfo, object: nil)
            
        default:
            break
        }
    }
}

// MARK: - 通知常量
extension Notification.Name {
    static let openTodayCalendar = Notification.Name("openTodayCalendar")
    static let openFestivalInfo = Notification.Name("openFestivalInfo")
}

// MARK: - 通知设置视图模型
class NotificationSettingsViewModel: ObservableObject {
    @Published var notificationService = NotificationService.shared
    @Published var selectedHour = 8
    @Published var selectedMinute = 0
    @Published var showingPermissionAlert = false
    
    init() {
        selectedHour = notificationService.reminderTime.hour ?? 8
        selectedMinute = notificationService.reminderTime.minute ?? 0
    }
    
    func requestPermissionIfNeeded() async {
        if !notificationService.isAuthorized {
            let granted = await notificationService.requestAuthorization()
            
            await MainActor.run {
                if !granted {
                    showingPermissionAlert = true
                }
            }
        }
    }
    
    func updateReminderTime() {
        notificationService.setReminderTime(hour: selectedHour, minute: selectedMinute)
    }
    
    func toggleDailyReminder() async {
        await requestPermissionIfNeeded()
        
        if notificationService.isAuthorized {
            notificationService.enableDailyReminder(!notificationService.dailyReminderEnabled)
        }
    }
} 