import SwiftUI
import UserNotifications

struct SettingsView: View {
    @StateObject private var userService = UserService.shared
    @State private var showingProfileSetup = false
    @State private var showingAbout = false
    @State private var showingNotificationSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 个人信息卡片
                    ModernProfileCard(
                        userProfile: userService.userProfile,
                        onEdit: { showingProfileSetup = true }
                    )
                    
                    // 功能设置卡片
                    SettingsSectionCard(title: "功能设置", icon: "gearshape.fill") {
                        VStack(spacing: 16) {
                            ModernNotificationRow(
                                settings: userService.notificationSettings,
                                onTap: { showingNotificationSettings = true }
                            )
                            
                            NavigationLink(destination: DataManagementView()) {
                                ModernSettingRow(
                                    icon: "externaldrive.fill",
                                    title: "数据管理",
                                    subtitle: "备份与恢复数据",
                                    gradient: .infoBlue,
                                    hasChevron: true
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    // 应用信息卡片
                    SettingsSectionCard(title: "应用信息", icon: "info.circle.fill") {
                        VStack(spacing: 16) {
                            Button(action: { showingAbout = true }) {
                                ModernSettingRow(
                                    icon: "info.circle.fill",
                                    title: "关于老黄历",
                                    subtitle: "版本信息与介绍",
                                    gradient: .warningOrange,
                                    hasChevron: true
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: UserAgreementView()) {
                                ModernSettingRow(
                                    icon: "doc.text.fill",
                                    title: "用户协议",
                                    subtitle: "服务条款",
                                    gradient: .mutedText,
                                    hasChevron: true
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: PrivacyPolicyView()) {
                                ModernSettingRow(
                                    icon: "hand.raised.fill",
                                    title: "隐私政策",
                                    subtitle: "数据保护说明",
                                    gradient: .successGreen,
                                    hasChevron: true
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    // 反馈与支持卡片
                    SettingsSectionCard(title: "反馈与支持", icon: "heart.fill") {
                        VStack(spacing: 16) {
                            Button(action: shareApp) {
                                ModernSettingRow(
                                    icon: "square.and.arrow.up.fill",
                                    title: "分享应用",
                                    subtitle: "推荐给朋友",
                                    gradient: .customSoftPurple,
                                    hasChevron: false
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: rateApp) {
                                ModernSettingRow(
                                    icon: "star.fill",
                                    title: "给个好评",
                                    subtitle: "App Store评价",
                                    gradient: .customGoldenYellow,
                                    hasChevron: false
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: FeedbackView()) {
                                ModernSettingRow(
                                    icon: "envelope.fill",
                                    title: "意见反馈",
                                    subtitle: "问题反馈与建议",
                                    gradient: .customJadeGreen,
                                    hasChevron: true
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    // 版本信息
                    VStack(spacing: 8) {
                        Text("老黄历")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.mutedText)
                        
                        Text("版本 1.0.0")
                            .font(.caption2)
                            .foregroundColor(.mutedText.opacity(0.7))
                    }
                    .padding(.top, 16)
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
            }
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

// MARK: - 现代化设置区块卡片
struct SettingsSectionCard<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 区块标题
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.heroGradient)
                        .frame(width: 32, height: 32)
                        .shadow(color: Color.primaryShadow, radius: 4, x: 0, y: 2)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryText)
                
                Spacer()
            }
            
            // 区块内容
            content
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - 现代化个人信息卡片
struct ModernProfileCard: View {
    let userProfile: UserProfile?
    let onEdit: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // 头像和基本信息
            HStack(spacing: 20) {
                // 头像
                ZStack {
                    Circle()
                        .fill(Color.heroGradient)
                        .frame(width: 72, height: 72)
                        .shadow(color: Color.primaryShadow, radius: 8, x: 0, y: 4)
                    
                    if let profile = userProfile {
                        Text(String(profile.zodiacSign.rawValue.prefix(1)))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: "person.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                
                // 用户信息
                VStack(alignment: .leading, spacing: 8) {
                    if let profile = userProfile {
                        Text("已设置个人信息")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryText)
                        
                        HStack(spacing: 12) {
                            ProfileTag(
                                text: profile.zodiacSign.rawValue,
                                gradient: LinearGradient(
                                    colors: [.customSoftPurple, .customRoyalBlue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            
                            ProfileTag(
                                text: profile.chineseZodiac.rawValue,
                                gradient: Color.festiveRedGradient
                            )
                        }
                    } else {
                        Text("欢迎使用老黄历")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryText)
                        
                        Text("设置生日获取专属运势")
                            .font(.subheadline)
                            .foregroundColor(.secondaryText)
                    }
                }
                
                Spacer()
            }
            
            // 编辑按钮
            Button(action: onEdit) {
                HStack(spacing: 8) {
                    Image(systemName: userProfile == nil ? "plus.circle.fill" : "pencil.circle.fill")
                        .font(.subheadline)
                    
                    Text(userProfile == nil ? "设置个人信息" : "编辑个人信息")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(Color.heroGradient)
                        .shadow(color: Color.auspiciousRed.opacity(0.3), radius: 4, x: 0, y: 2)
                )
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - 个人信息标签
struct ProfileTag: View {
    let text: String
    let gradient: LinearGradient
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(gradient)
                    .shadow(color: Color.primaryShadow, radius: 2, x: 0, y: 1)
            )
    }
}

// MARK: - 现代化设置行
struct ModernSettingRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: Color
    let hasChevron: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // 图标
            ZStack {
                Circle()
                    .fill(gradient.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(gradient)
            }
            
            // 文本内容
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryText)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondaryText)
            }
            
            Spacer()
            
            // 指示器
            if hasChevron {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.mutedText)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appSecondaryBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(gradient.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// MARK: - 现代化通知设置行
struct ModernNotificationRow: View {
    let settings: NotificationSettings
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // 图标
                ZStack {
                    Circle()
                        .fill(settings.isEnabled ? Color.auspiciousRed.opacity(0.15) : Color.mutedText.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: settings.isEnabled ? "bell.fill" : "bell.slash.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(settings.isEnabled ? .auspiciousRed : .mutedText)
                }
                
                // 文本内容
                VStack(alignment: .leading, spacing: 4) {
                    Text("通知提醒")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.primaryText)
                    
                    Text(settings.isEnabled ? "每日 \(String(format: "%02d:%02d", settings.hour, settings.minute)) 推送提醒" : "未开启通知")
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                }
                
                Spacer()
                
                // 状态和箭头
                HStack(spacing: 8) {
                    Circle()
                        .fill(settings.isEnabled ? Color.successGreen : Color.mutedText.opacity(0.5))
                        .frame(width: 8, height: 8)
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.mutedText)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.appSecondaryBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(settings.isEnabled ? Color.auspiciousRed.opacity(0.2) : Color.mutedText.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
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
            ScrollView {
                VStack(spacing: 24) {
                    // 主开关卡片
                    VStack(spacing: 20) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.heroGradient)
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: "bell.fill")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            
                            Text("通知设置")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.primaryText)
                            
                            Spacer()
                        }
                        
                        VStack(spacing: 16) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("开启每日提醒")
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primaryText)
                                    
                                    Text("每天定时推送黄历信息")
                                        .font(.caption)
                                        .foregroundColor(.secondaryText)
                                }
                                
                                Spacer()
                                
                                Toggle("", isOn: $settings.isEnabled)
                                    .tint(.auspiciousRed)
                                    .onChange(of: settings.isEnabled) { oldValue, newValue in
                                        if newValue {
                                            requestNotificationPermission()
                                        }
                                    }
                            }
                        }
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.cardBackground)
                            .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 4)
                    )
                    
                    // 时间设置卡片
                    if settings.isEnabled {
                        VStack(spacing: 20) {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(LinearGradient(colors: [.customGoldenYellow, .warningOrange], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .frame(width: 32, height: 32)
                                    
                                    Image(systemName: "clock.fill")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                
                                Text("提醒时间")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primaryText)
                                
                                Spacer()
                            }
                            
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
                            .labelsHidden()
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.cardBackground)
                                .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 4)
                        )
                        
                        // 内容选择卡片
                        VStack(spacing: 20) {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(LinearGradient(colors: [.customJadeGreen, .successGreen], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .frame(width: 32, height: 32)
                                    
                                    Image(systemName: "list.bullet")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                
                                Text("提醒内容")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primaryText)
                                
                                Spacer()
                            }
                            
                            VStack(spacing: 16) {
                                NotificationToggleRow(
                                    icon: "yin.yang",
                                    title: "今日宜忌",
                                    subtitle: "每日黄历建议",
                                    isOn: $settings.includeAdvice,
                                    color: .auspiciousRed
                                )
                                
                                NotificationToggleRow(
                                    icon: "star.fill",
                                    title: "个人运势",
                                    subtitle: "专属运势分析",
                                    isOn: $settings.includeFortune,
                                    color: .customGoldenYellow
                                )
                                
                                NotificationToggleRow(
                                    icon: "leaf.fill",
                                    title: "节日节气",
                                    subtitle: "传统节日提醒",
                                    isOn: $settings.includeFestivals,
                                    color: .customJadeGreen
                                )
                            }
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.cardBackground)
                                .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 4)
                        )
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
            }
            .background(Color.homeBackgroundGradient.ignoresSafeArea())
            .navigationTitle("通知设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                    .foregroundColor(.auspiciousRed)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        userService.updateNotificationSettings(settings)
                        dismiss()
                    }
                    .foregroundColor(.auspiciousRed)
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
            Text("请在系统设置中开启通知权限，以便接收黄历提醒。")
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

// MARK: - 通知切换行
struct NotificationToggleRow: View {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primaryText)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondaryText)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .tint(.auspiciousRed)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appSecondaryBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
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
                    VStack(spacing: 20) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.heroGradient)
                                .frame(width: 120, height: 120)
                                .shadow(color: Color.auspiciousRed.opacity(0.3), radius: 12, x: 0, y: 6)
                            
                            Image(systemName: "calendar.chinese")
                                .font(.system(size: 60, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 8) {
                            Text("老黄历")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primaryText)
                            
                            Text("版本 1.0.0")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondaryText)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(Color.appSecondaryBackground)
                                )
                        }
                    }
                    
                    // 应用介绍卡片
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.infoBlue.opacity(0.15))
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: "text.alignleft")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.infoBlue)
                            }
                            
                            Text("应用介绍")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.primaryText)
                            
                            Spacer()
                        }
                        
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
                        .foregroundColor(.secondaryText)
                        .lineSpacing(6)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.cardBackground)
                            .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 4)
                    )
                    
                    // 开发信息卡片
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.customJadeGreen.opacity(0.15))
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: "hammer.fill")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.customJadeGreen)
                            }
                            
                            Text("开发信息")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.primaryText)
                            
                            Spacer()
                        }
                        
                        VStack(spacing: 16) {
                            ModernInfoRow(title: "开发者", value: "老黄历团队")
                            ModernInfoRow(title: "技术栈", value: "SwiftUI + iOS")
                            ModernInfoRow(title: "设计理念", value: "传统与现代的完美融合")
                            ModernInfoRow(title: "更新日期", value: "2024年5月")
                        }
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.cardBackground)
                            .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 4)
                    )
                    
                    // 致谢卡片
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.auspiciousRed.opacity(0.15))
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.auspiciousRed)
                            }
                            
                            Text("特别致谢")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.primaryText)
                            
                            Spacer()
                        }
                        
                        Text("感谢所有用户的支持与反馈，让我们能够不断改进和完善这款应用。")
                            .font(.body)
                            .foregroundColor(.secondaryText)
                            .lineSpacing(6)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.cardBackground)
                            .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 4)
                    )
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
            }
            .background(Color.homeBackgroundGradient.ignoresSafeArea())
            .navigationTitle("关于")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                    .foregroundColor(.auspiciousRed)
                }
            }
        }
    }
}

// MARK: - 现代化信息行
struct ModernInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(.secondaryText)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.primaryText)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    SettingsView()
} 