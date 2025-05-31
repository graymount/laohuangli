import SwiftUI

struct HomeView: View {
    @StateObject private var calendarService = CalendarService.shared
    @StateObject private var userService = UserService.shared
    @State private var currentDate = Date()
    @State private var calendarInfo: CalendarDate?
    @State private var showingAdviceDetail = false
    @State private var selectedDate = Date()
    @State private var displayedMonth = Date()
    @State private var showingShareSheet = false
    @State private var shareItems: [Any] = []
    
    // 新增状态变量用于导航
    @State private var showingFortuneView = false
    @State private var showingAuspiciousDaysView = false
    @State private var showingNotificationSettingsSheet = false
    @State private var showingAppSettingsSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 顶部日期卡片
                    DateHeaderCard(calendarInfo: calendarInfo)
                    
                    // 月历组件
                    MonthCalendarCard(
                        selectedDate: $selectedDate,
                        displayedMonth: $displayedMonth,
                        onDateSelected: { date in
                            selectedDate = date
                            currentDate = date
                            loadCalendarInfo()
                        }
                    )
                    
                    // 今日宜忌卡片
                    if let advice = calendarInfo?.dailyAdvice {
                        DailyAdviceCard(advice: advice) {
                            showingAdviceDetail = true
                        }
                    }
                    
                    // 节气和节日信息
                    if let calendarInfo = calendarInfo {
                        SolarTermAndFestivalCard(calendarInfo: calendarInfo)
                    }
                    
                    // 快速功能入口
                    QuickActionsCard(
                        showingFortuneView: $showingFortuneView,
                        showingAuspiciousDaysView: $showingAuspiciousDaysView,
                        showingNotificationSettingsSheet: $showingNotificationSettingsSheet,
                        showingAppSettingsSheet: $showingAppSettingsSheet
                    )
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
            }
            .background(Color.homeBackgroundGradient)
            .navigationTitle("老黄历")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let calendarInfo = calendarInfo {
                        Button {
                            showShareSheet(for: calendarInfo)
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.auspiciousRed)
                        }
                    }
                }
            }
            .refreshable {
                loadCalendarInfo()
            }
            .sheet(isPresented: $showingAdviceDetail) {
                if let advice = calendarInfo?.dailyAdvice {
                    AdviceDetailView(advice: advice)
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                CalendarShareSheet(items: shareItems)
            }
            .sheet(isPresented: $showingNotificationSettingsSheet) {
                NotificationSettingsView(settings: userService.notificationSettings)
            }
            .sheet(isPresented: $showingAppSettingsSheet) {
                SettingsView()
            }
            .background(
                VStack {
                    NavigationLink(destination: FortuneView(), isActive: $showingFortuneView) { EmptyView() }
                    NavigationLink(destination: AuspiciousDaysView(), isActive: $showingAuspiciousDaysView) { EmptyView() }
                }
            )
        }
        .onAppear {
            selectedDate = currentDate
            displayedMonth = currentDate
            loadCalendarInfo()
        }
    }
    
    private func loadCalendarInfo() {
        calendarInfo = calendarService.getCalendarInfo(for: currentDate)
    }
    
    private func showShareSheet(for calendarInfo: CalendarDate) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日"
        let dateString = formatter.string(from: calendarInfo.gregorianDate)
        
        let shareText = """
        📅 \(dateString) (\(calendarInfo.weekday))
        🌙 农历: \(calendarInfo.lunarDate.month)\(calendarInfo.lunarDate.day)
        🐲 生肖: \(calendarInfo.zodiacYear)
        
        ✅ 宜: \(calendarInfo.dailyAdvice.suitable.prefix(3).joined(separator: "、"))
        ❌ 忌: \(calendarInfo.dailyAdvice.unsuitable.prefix(3).joined(separator: "、"))
        
        #老黄历 #传统文化 #每日宜忌
        """
        
        shareItems = [shareText]
        showingShareSheet = true
    }
}

// MARK: - 日期头部卡片
struct DateHeaderCard: View {
    let calendarInfo: CalendarDate?
    
    var body: some View {
        VStack(spacing: 24) {
            // 主要日期信息
            HStack(alignment: .top) {
                // 公历日期区域
                VStack(alignment: .leading, spacing: 4) {
                    Text(formatGregorianDate())
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.heroGradient)
                    
                    Text(calendarInfo?.weekday ?? "")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.secondaryText)
                }
                
                Spacer()
                
                // 装饰元素 - 简化版
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.heroGradient)
                            .frame(width: 48, height: 48)
                            .shadow(color: Color.primaryShadow, radius: 8, x: 0, y: 4)
                        
                        Image(systemName: "sun.max.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Text("今日")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.mutedText)
                }
            }
            
            // 农历信息区域
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    if let lunar = calendarInfo?.lunarDate {
                        Text("\(lunar.month)\(lunar.day)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryText)
                    }
                    
                    Text(calendarInfo?.zodiacYear ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondaryText)
                }
                
                Spacer()
                
                // 农历标签 - 现代化设计
                HStack(spacing: 6) {
                    Image(systemName: "moon.stars.fill")
                        .font(.caption)
                        .foregroundColor(.auspiciousRed)
                    
                    Text("农历")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.auspiciousRed)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.festiveAccent)
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
    
    private func formatGregorianDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日"
        return formatter.string(from: calendarInfo?.gregorianDate ?? Date())
    }
}

// MARK: - 今日宜忌卡片
struct DailyAdviceCard: View {
    let advice: DailyAdvice
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 标题区域
            HStack {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.heroGradient)
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "yin.yang")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("今日宜忌")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryText)
                        
                        Text("查看详细建议")
                            .font(.caption)
                            .foregroundColor(.mutedText)
                    }
                }
                
                Spacer()
                
                Button(action: onTap) {
                    HStack(spacing: 4) {
                        Text("详情")
                            .font(.caption)
                            .fontWeight(.medium)
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    .foregroundColor(.auspiciousRed)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.festiveAccent)
                    )
                }
            }
            
            // 宜忌内容区域
            HStack(spacing: 16) {
                // 宜
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.successGreen)
                            .font(.title3)
                        
                        Text("宜")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.successGreen)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(advice.suitable.prefix(3), id: \.self) { item in
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color.successGreen)
                                    .frame(width: 6, height: 6)
                                
                                Text(item)
                                    .font(.subheadline)
                                    .foregroundColor(.primaryText)
                                    .lineLimit(1)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.successGreen.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.successGreen.opacity(0.2), lineWidth: 1)
                        )
                )
                
                // 忌
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.auspiciousRed)
                            .font(.title3)
                        
                        Text("忌")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.auspiciousRed)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(advice.unsuitable.prefix(3), id: \.self) { item in
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color.auspiciousRed)
                                    .frame(width: 6, height: 6)
                                
                                Text(item)
                                    .font(.subheadline)
                                    .foregroundColor(.primaryText)
                                    .lineLimit(1)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.auspiciousRed.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.auspiciousRed.opacity(0.2), lineWidth: 1)
                        )
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 4)
        )
        .onTapGesture {
            onTap()
        }
    }
}

// MARK: - 节气节日卡片
struct SolarTermAndFestivalCard: View {
    let calendarInfo: CalendarDate
    
    var body: some View {
        if calendarInfo.solarTerm != nil || calendarInfo.festival != nil {
            VStack(alignment: .leading, spacing: 16) {
                // 顶部装饰条
                Rectangle()
                    .fill(Color.festiveRedGradient)
                    .frame(height: 3)
                    .cornerRadius(1.5)
                
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.festiveRedGradient)
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: "sparkles")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    
                    Text("节气节日")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.luckyRedGradient)
                }
                
                HStack(spacing: 16) {
                    if let solarTerm = calendarInfo.solarTerm {
                        EnhancedFeatureTag(
                            icon: "leaf.fill",
                            text: solarTerm,
                            gradient: Color.jadeGradient
                        )
                    }
                    
                    if let festival = calendarInfo.festival {
                        EnhancedFeatureTag(
                            icon: "party.popper.fill",
                            text: festival,
                            gradient: Color.festiveRedGradient
                        )
                    }
                    
                    Spacer()
                }
                
                // 底部装饰条
                Rectangle()
                    .fill(Color.festiveRedGradient)
                    .frame(height: 3)
                    .cornerRadius(1.5)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.cardBackgroundGradient)
                    .shadow(color: Color.cardShadow, radius: 12, x: 0, y: 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.darkRedBorder, lineWidth: 2)
                    )
            )
        }
    }
}

// MARK: - 快速功能卡片
struct QuickActionsCard: View {
    @Binding var showingFortuneView: Bool
    @Binding var showingAuspiciousDaysView: Bool
    @Binding var showingNotificationSettingsSheet: Bool
    @Binding var showingAppSettingsSheet: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // 顶部装饰条
            Rectangle()
                .fill(Color.festiveRedGradient)
                .frame(height: 3)
                .cornerRadius(1.5)
            
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color.festiveRedGradient)
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "bolt.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                }
                
                Text("快速功能")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.luckyRedGradient)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                EnhancedQuickActionButton(
                    icon: "wand.and.stars.inverse",
                    title: "今日运势",
                    subtitle: "查看个人运势",
                    gradient: Color.festiveRedGradient
                ) {
                    showingFortuneView = true
                }
                
                EnhancedQuickActionButton(
                    icon: "magnifyingglass",
                    title: "吉日查询",
                    subtitle: "寻找黄道吉日",
                    gradient: Color.luckyRedGradient
                ) {
                    showingAuspiciousDaysView = true
                }
                
                EnhancedQuickActionButton(
                    icon: "bell.fill",
                    title: "提醒设置",
                    subtitle: "设置每日提醒",
                    gradient: Color.goldenGradient
                ) {
                    showingNotificationSettingsSheet = true
                }
                
                EnhancedQuickActionButton(
                    icon: "gearshape.fill",
                    title: "应用设置",
                    subtitle: "个人信息设置",
                    gradient: Color.celebrationGradient
                ) {
                    showingAppSettingsSheet = true
                }
            }
            
            // 底部装饰条
            Rectangle()
                .fill(Color.festiveRedGradient)
                .frame(height: 3)
                .cornerRadius(1.5)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardBackgroundGradient)
                .shadow(color: Color.cardShadow, radius: 12, x: 0, y: 6)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.darkRedBorder, lineWidth: 2)
                )
        )
    }
}

// MARK: - 增强的辅助组件
struct EnhancedFeatureTag: View {
    let icon: String
    let text: String
    let gradient: LinearGradient
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.white)
            Text(text)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(gradient)
                .shadow(color: Color.cardShadow, radius: 4, x: 0, y: 2)
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct EnhancedQuickActionButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: LinearGradient
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(gradient)
                            .frame(width: 40, height: 40)
                            .shadow(color: Color.cardShadow, radius: 4, x: 0, y: 2)
                        
                        Image(systemName: icon)
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6).opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(gradient, lineWidth: 1.5)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - 月历卡片组件
struct MonthCalendarCard: View {
    @Binding var selectedDate: Date
    @Binding var displayedMonth: Date
    let onDateSelected: (Date) -> Void
    
    @State private var calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 20) {
            // 月份导航头部
            HStack {
                Button(action: previousMonth) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                        Text("上月")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.auspiciousRed)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.festiveAccent)
                    )
                }
                
                Spacer()
                
                VStack(spacing: 2) {
                    Text(monthYearString)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryText)
                    
                    Text("农历 \(getCurrentLunarMonth())")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondaryText)
                }
                
                Spacer()
                
                Button(action: nextMonth) {
                    HStack(spacing: 6) {
                        Text("下月")
                            .font(.caption)
                            .fontWeight(.medium)
                        Image(systemName: "chevron.right")
                            .font(.headline)
                    }
                    .foregroundColor(.auspiciousRed)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.festiveAccent)
                    )
                }
            }
            .padding(.horizontal, 4)
            
            // 星期标题
            HStack(spacing: 0) {
                ForEach(Array(weekdaySymbols.enumerated()), id: \.offset) { index, weekday in
                    Text(weekday)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(index == 0 || index == 6 ? .auspiciousRed : .primaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 8)
            
            // 日期网格 - 增加间距以适应更多信息
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 12) {
                ForEach(daysInMonth.indices, id: \.self) { index in
                    if let date = daysInMonth[index] {
                        EnhancedCalendarDayView(
                            date: date,
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            isToday: calendar.isDateInToday(date),
                            isCurrentMonth: calendar.isDate(date, equalTo: displayedMonth, toGranularity: .month)
                        ) {
                            selectedDate = date
                            onDateSelected(date)
                        }
                    } else {
                        Color.clear
                            .frame(height: 52) // 匹配日期格子高度
                    }
                }
            }
            .padding(.horizontal, 4)
            
            // 底部图例说明
            HStack(spacing: 16) {
                LegendItem(color: .auspiciousRed, text: "节日")
                LegendItem(color: .successGreen, text: "节气")
                LegendItem(color: .infoBlue, text: "纪念日")
                LegendItem(color: .secondaryText, text: "农历")
                Spacer()
            }
            .padding(.horizontal, 8)
            .padding(.top, 8)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 4)
        )
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月"
        return formatter.string(from: displayedMonth)
    }
    
    private var weekdaySymbols: [String] {
        return ["日", "一", "二", "三", "四", "五", "六"]
    }
    
    private func getCurrentLunarMonth() -> String {
        let calendarService = CalendarService.shared
        let calendarInfo = calendarService.getCalendarInfo(for: displayedMonth)
        return calendarInfo.lunarDate.month
    }
    
    private var daysInMonth: [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.end - 1) else {
            return []
        }
        
        var days: [Date?] = []
        var date = monthFirstWeek.start
        
        while date < monthLastWeek.end {
            // 包含所有日期，不论是否属于当前月份
            days.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date) ?? date
        }
        
        return days
    }
    
    private func previousMonth() {
        displayedMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth
    }
    
    private func nextMonth() {
        displayedMonth = calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth
    }
}

// MARK: - 图例组件
struct LegendItem: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondaryText)
        }
    }
}

// MARK: - 增强的日历日期视图
struct EnhancedCalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let isCurrentMonth: Bool
    let onTap: () -> Void
    
    @StateObject private var calendarService = CalendarService.shared
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                // 公历日期 - 主要显示
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.system(size: isSelected ? 20 : 18, weight: isSelected ? .bold : .semibold))
                    .foregroundColor(gregorianTextColor)
                
                // 农历、节日或节气信息
                if isCurrentMonth {
                    VStack(spacing: 1) {
                        // 优先显示节日
                        if let festival = getFestivalInfo() {
                            Text(festival.text)
                                .font(.system(size: 8, weight: .medium))
                                .foregroundColor(festival.color)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                        // 显示节气
                        else if let solarTerm = getSolarTermInfo() {
                            Text(solarTerm.text)
                                .font(.system(size: 8, weight: .medium))
                                .foregroundColor(solarTerm.color)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                        // 显示农历日期
                        else if let lunar = getLunarInfo() {
                            Text(lunar.text)
                                .font(.system(size: 8, weight: .medium))
                                .foregroundColor(lunar.color)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                        // 保持布局稳定的占位符
                        else {
                            Text(" ")
                                .font(.system(size: 8))
                        }
                    }
                }
            }
            .frame(width: 48, height: 52) // 增加高度以容纳更多信息
            .background(backgroundColor)
            .cornerRadius(isSelected ? 12 : 8)
            .overlay(
                RoundedRectangle(cornerRadius: isSelected ? 12 : 8)
                    .stroke(borderColor, lineWidth: getBorderWidth())
            )
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowOffset)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var gregorianTextColor: Color {
        if isSelected {
            return isToday ? .white : .auspiciousRed // 选中日期：今日用白字，其他用红字
        } else if isToday {
            return .primaryText // 今日未选中用普通文字
        } else if !isCurrentMonth {
            return .mutedText // 非当前月份用灰色
        } else if isWeekend {
            return .auspiciousRed // 周末红色
        } else {
            return .primaryText
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return isToday ? Color.auspiciousRed : Color.clear // 只有今日被选中才用红色背景
        } else if isToday {
            return Color.secondaryBackground // 今日未选中用灰色背景
        } else if !isCurrentMonth {
            return Color.clear // 非当前月份透明背景
        } else if isFestival {
            return Color.festiveAccent
        } else {
            return Color.clear
        }
    }
    
    private var borderColor: Color {
        if isSelected && !isToday {
            return .auspiciousRed // 选中的非今日用红色边框（不论是否当前月）
        } else if isToday && !isSelected {
            return .secondaryText.opacity(0.5) // 今日未选中用淡灰边框
        } else {
            return .clear
        }
    }
    
    private var shadowColor: Color {
        if isSelected {
            return Color.auspiciousRed.opacity(0.3)
        } else if isToday {
            return Color.secondaryText.opacity(0.2)
        } else {
            return .clear
        }
    }
    
    private var shadowRadius: CGFloat {
        return (isSelected || isToday) ? 4 : 0
    }
    
    private var shadowOffset: CGFloat {
        return (isSelected || isToday) ? 2 : 0
    }
    
    private var isWeekend: Bool {
        let weekday = Calendar.current.component(.weekday, from: date)
        return weekday == 1 || weekday == 7 // 周日=1, 周六=7
    }
    
    private var isFestival: Bool {
        let calendarInfo = calendarService.getCalendarInfo(for: date)
        return calendarInfo.festival != nil && !calendarInfo.festival!.isEmpty
    }
    
    // 获取节日信息
    private func getFestivalInfo() -> (text: String, color: Color)? {
        let calendarInfo = calendarService.getCalendarInfo(for: date)
        
        if let festival = calendarInfo.festival, !festival.isEmpty {
            // 根据节日类型使用不同颜色
            let color: Color
            if festival.contains("节") {
                color = .auspiciousRed // 传统节日用红色
            } else if festival.contains("日") {
                color = .infoBlue // 纪念日用蓝色
            } else {
                color = .warningOrange // 其他用橙色
            }
            
            // 限制显示字符数
            let displayText = festival.count > 4 ? String(festival.prefix(3)) + "…" : festival
            return (displayText, color)
        }
        return nil
    }
    
    // 获取节气信息
    private func getSolarTermInfo() -> (text: String, color: Color)? {
        let calendarInfo = calendarService.getCalendarInfo(for: date)
        
        if let solarTerm = calendarInfo.solarTerm, !solarTerm.isEmpty {
            return (solarTerm, .successGreen) // 节气用绿色
        }
        return nil
    }
    
    // 获取农历信息
    private func getLunarInfo() -> (text: String, color: Color)? {
        let calendarInfo = calendarService.getCalendarInfo(for: date)
        let lunar = calendarInfo.lunarDate
        
        // 农历初一显示月份
        if lunar.day == "初一" {
            let monthText = lunar.month.count > 3 ? String(lunar.month.prefix(2)) : lunar.month
            return (monthText, .auspiciousRed)
        }
        // 其他日期显示农历日
        else {
            let dayText = lunar.day.count > 3 ? String(lunar.day.prefix(3)) : lunar.day
            return (dayText, .secondaryText)
        }
    }
    
    private func getBorderWidth() -> CGFloat {
        if isSelected && !isToday {
            return 2 // 选中边框较粗（不论是否当前月）
        } else if isToday && !isSelected {
            return 0.5 // 今日边框较细
        } else {
            return 0
        }
    }
}

#Preview {
    HomeView()
} 