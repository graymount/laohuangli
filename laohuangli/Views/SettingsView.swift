import SwiftUI
import UserNotifications

struct SettingsView: View {
    @StateObject private var userService = UserService.shared
    @State private var showingProfileSetup = false
    @State private var showingAbout = false
    @State private var showingNotificationSettings = false
    
    var body: some View {
        NavigationView {
            List {
                // 个人信息区块
                Section {
                    ProfileSection(
                        userProfile: userService.userProfile,
                        onEdit: { showingProfileSetup = true }
                    )
                }
                
                // 功能设置区块
                Section {
                    NotificationSettingRow(
                        settings: userService.notificationSettings,
                        onTap: { showingNotificationSettings = true }
                    )
                    
                    NavigationLink(destination: DataManagementView()) {
                        SettingRow(
                            icon: "externaldrive",
                            title: "数据管理",
                            subtitle: "备份与恢复",
                            color: .blue
                        )
                    }
                } header: {
                    Text("功能设置")
                }
                
                // 应用信息区块
                Section {
                    Button(action: { showingAbout = true }) {
                        SettingRow(
                            icon: "info.circle",
                            title: "关于老黄历",
                            subtitle: "版本信息与介绍",
                            color: .orange
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: UserAgreementView()) {
                        SettingRow(
                            icon: "doc.text",
                            title: "用户协议",
                            subtitle: "服务条款",
                            color: .gray
                        )
                    }
                    
                    NavigationLink(destination: PrivacyPolicyView()) {
                        SettingRow(
                            icon: "hand.raised",
                            title: "隐私政策",
                            subtitle: "数据保护说明",
                            color: .green
                        )
                    }
                } header: {
                    Text("应用信息")
                }
                
                // 反馈与支持区块
                Section {
                    Button(action: shareApp) {
                        SettingRow(
                            icon: "square.and.arrow.up",
                            title: "分享应用",
                            subtitle: "推荐给朋友",
                            color: .purple
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: rateApp) {
                        SettingRow(
                            icon: "star.fill",
                            title: "给个好评",
                            subtitle: "App Store评价",
                            color: .yellow
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: FeedbackView()) {
                        SettingRow(
                            icon: "envelope.fill",
                            title: "意见反馈",
                            subtitle: "问题反馈与建议",
                            color: .green
                        )
                    }
                } header: {
                    Text("反馈与支持")
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.homeBackgroundGradient.ignoresSafeArea())
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingProfileSetup) {
            ProfileSetupView()
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
        .sheet(isPresented: $showingNotificationSettings) {
            NotificationSettingsView(settings: userService.notificationSettings)
        }
    }
    
    private func shareApp() {
        let shareText = """
        推荐一款很棒的老黄历App！
        
        🌟 现代设计，传统智慧
        📅 每日宜忌，运势分析
        🔍 吉日查询，精准推荐
        
        快来下载体验吧！
        """
        
        let activityVC = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
    
    private func rateApp() {
        // 在实际应用中，这里应该跳转到App Store评价页面
        if let url = URL(string: "https://apps.apple.com/app/id123456789") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - 个人信息区块
struct ProfileSection: View {
    let userProfile: UserProfile?
    let onEdit: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // 头像
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.purple, .blue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                )
            
            // 用户信息
            VStack(alignment: .leading, spacing: 4) {
                if let profile = userProfile {
                    Text("已设置个人信息")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 12) {
                        Text(profile.zodiacSign.rawValue)
                            .font(.body)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.purple.opacity(0.1))
                            .foregroundColor(.purple)
                            .cornerRadius(8)
                        
                        Text(profile.chineseZodiac.rawValue)
                            .font(.body)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
                            .cornerRadius(8)
                    }
                } else {
                    Text("未设置个人信息")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("设置生日获取专属运势")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // 编辑按钮
            Button(action: onEdit) {
                Text(userProfile == nil ? "设置" : "编辑")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - 通知设置行
struct NotificationSettingRow: View {
    let settings: NotificationSettings
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // 图标
                ZStack {
                    Circle()
                        .fill(settings.isEnabled ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: settings.isEnabled ? "bell.fill" : "bell.slash")
                        .font(.title3)
                        .foregroundColor(settings.isEnabled ? .blue : .gray)
                }
                
                // 文本内容
                VStack(alignment: .leading, spacing: 4) {
                    Text("通知提醒")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(settings.isEnabled ? "每日 \(String(format: "%02d:%02d", settings.hour, settings.minute)) 提醒" : "未开启")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // 状态指示
                Circle()
                    .fill(settings.isEnabled ? Color.green : Color.gray.opacity(0.3))
                    .frame(width: 8, height: 8)
                
                Image(systemName: "chevron.right")
                    .font(.body)
                    .foregroundColor(.secondary.opacity(0.6))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cardBackgroundGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.darkRedBorder, lineWidth: 1.5)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - 设置行组件
struct SettingRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            // 图标
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
            }
            
            // 文本内容
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // 箭头指示
            Image(systemName: "chevron.right")
                .font(.body)
                .foregroundColor(.secondary.opacity(0.6))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cardBackgroundGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.darkRedBorder, lineWidth: 1.5)
                )
        )
    }
}

// MARK: - 通知设置视图
struct NotificationSettingsView: View {
    @StateObject private var userService = UserService.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var settings: NotificationSettings
    @State private var showingPermissionAlert = false
    
    init(settings: NotificationSettings) {
        _settings = State(initialValue: settings)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("开启通知提醒", isOn: $settings.isEnabled)
                        .onChange(of: settings.isEnabled) { oldValue, newValue in
                            if newValue {
                                requestNotificationPermission()
                            }
                        }
                } footer: {
                    Text("开启后将在指定时间推送每日黄历提醒")
                }
                
                if settings.isEnabled {
                    Section {
                        DatePicker(
                            "提醒时间",
                            selection: Binding(
                                get: {
                                    Calendar.current.date(
                                        bySettingHour: settings.hour,
                                        minute: settings.minute,
                                        second: 0,
                                        of: Date()
                                    ) ?? Date()
                                },
                                set: { newDate in
                                    let components = Calendar.current.dateComponents([.hour, .minute], from: newDate)
                                    settings.hour = components.hour ?? 8
                                    settings.minute = components.minute ?? 0
                                }
                            ),
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.wheel)
                    } header: {
                        Text("提醒时间")
                    }
                    
                    Section {
                        Toggle("今日宜忌", isOn: $settings.includeAdvice)
                        Toggle("个人运势", isOn: $settings.includeFortune)
                        Toggle("节日节气", isOn: $settings.includeFestivals)
                    } header: {
                        Text("提醒内容")
                    }
                }
            }
            .navigationTitle("通知设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        userService.updateNotificationSettings(settings)
                        dismiss()
                    }
                }
            }
        }
        .alert("需要通知权限", isPresented: $showingPermissionAlert) {
            Button("取消", role: .cancel) {
                settings.isEnabled = false
            }
            Button("去设置") {
                openAppSettings()
            }
        } message: {
            Text("请在系统设置中允许老黄历发送通知")
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if !granted {
                    showingPermissionAlert = true
                }
            }
        }
    }
    
    private func openAppSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}

// MARK: - 关于应用视图
struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // 应用图标和名称
                    VStack(spacing: 16) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.red, .orange]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "calendar.chinese")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                            )
                        
                        VStack(spacing: 8) {
                            Text("老黄历")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("版本 1.0.0")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // 应用介绍
                    VStack(alignment: .leading, spacing: 16) {
                        Text("应用介绍")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("""
                        老黄历是一款融合传统文化与现代设计的应用，为您提供：
                        
                        📅 每日黄历信息，包含宜忌事项
                        🌟 个性化运势分析
                        🔍 智能吉日查询
                        📤 便捷分享功能
                        🔔 贴心提醒服务
                        
                        传承千年智慧，服务现代生活。
                        """)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // 开发信息
                    VStack(alignment: .leading, spacing: 16) {
                        Text("开发信息")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 12) {
                            InfoRow(title: "开发者", value: "老黄历团队")
                            InfoRow(title: "技术栈", value: "SwiftUI + iOS")
                            InfoRow(title: "设计理念", value: "传统与现代的完美融合")
                            InfoRow(title: "更新日期", value: "2024年5月")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // 致谢
                    VStack(alignment: .leading, spacing: 16) {
                        Text("特别致谢")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("感谢所有用户的支持与反馈，让我们能够不断改进和完善这款应用。")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
            }
            .navigationTitle("关于")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    SettingsView()
} 