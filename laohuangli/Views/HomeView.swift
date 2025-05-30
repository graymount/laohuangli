import SwiftUI

struct HomeView: View {
    @StateObject private var calendarService = CalendarService.shared
    @StateObject private var userService = UserService.shared
    @State private var currentDate = Date()
    @State private var calendarInfo: CalendarDate?
    @State private var showingAdviceDetail = false
    @State private var selectedDate = Date()
    @State private var displayedMonth = Date()
    
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
                    QuickActionsCard()
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
            }
            .background(Color.homeBackgroundGradient)
            .navigationTitle("老黄历")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                loadCalendarInfo()
            }
        }
        .onAppear {
            selectedDate = currentDate
            displayedMonth = currentDate
            loadCalendarInfo()
        }
        .sheet(isPresented: $showingAdviceDetail) {
            if let advice = calendarInfo?.dailyAdvice {
                AdviceDetailView(advice: advice)
            }
        }
    }
    
    private func loadCalendarInfo() {
        calendarInfo = calendarService.getCalendarInfo(for: currentDate)
    }
}

// MARK: - 日期头部卡片
struct DateHeaderCard: View {
    let calendarInfo: CalendarDate?
    
    var body: some View {
        VStack(spacing: 16) {
            // 喜庆装饰边框
            Rectangle()
                .fill(Color.festiveRedGradient)
                .frame(height: 4)
                .cornerRadius(2)
            
            // 公历日期
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(formatGregorianDate())
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.luckyRedGradient)
                    
                    Text(calendarInfo?.weekday ?? "")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.auspiciousRed)
                }
                
                Spacer()
                
                // 中国风装饰元素
                ZStack {
                    Circle()
                        .fill(Color.festiveRedGradient)
                        .frame(width: 60, height: 60)
                        .shadow(color: Color.accentShadow, radius: 8, x: 0, y: 4)
                    
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                }
            }
            
            // 装饰性分割线
            Rectangle()
                .fill(Color.celebrationGradient)
                .frame(height: 3)
                .cornerRadius(1.5)
            
            // 农历日期和生肖年
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    if let lunar = calendarInfo?.lunarDate {
                        Text("\(lunar.month)\(lunar.day)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.luckyRedGradient)
                    }
                    
                    Text(calendarInfo?.zodiacYear ?? "")
                        .font(.subheadline)
                        .foregroundColor(.auspiciousRed)
                }
                
                Spacer()
                
                // 农历年份装饰
                HStack(spacing: 4) {
                    Image(systemName: "moon.stars.fill")
                        .font(.body)
                        .foregroundColor(.goldenYellow)
                    
                    Text("农历")
                        .font(.body)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.festiveAccent)
                        .overlay(
                            Capsule()
                                .stroke(Color.luckyBorder, lineWidth: 1.5)
                        )
                )
                .foregroundColor(.auspiciousRed)
            }
            
            // 底部喜庆装饰边框
            Rectangle()
                .fill(Color.festiveRedGradient)
                .frame(height: 4)
                .cornerRadius(2)
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
        VStack(alignment: .leading, spacing: 18) {
            // 顶部装饰条
            Rectangle()
                .fill(Color.festiveRedGradient)
                .frame(height: 3)
                .cornerRadius(1.5)
            
            HStack {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.festiveRedGradient)
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: "yin.yang")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    
                    Text("今日宜忌")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.luckyRedGradient)
                }
                
                Spacer()
                
                Button(action: onTap) {
                    ZStack {
                        Circle()
                            .fill(Color.festiveAccent)
                            .frame(width: 36, height: 36)
                        
                        Image(systemName: "info.circle.fill")
                            .font(.title3)
                            .foregroundColor(.auspiciousRed)
                    }
                }
            }
            
            HStack(alignment: .top, spacing: 24) {
                // 宜
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.jadeGreen)
                        Text("宜")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.jadeGreen)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(advice.suitable.prefix(3), id: \.self) { item in
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(Color.jadeGreen.opacity(0.6))
                                    .frame(width: 4, height: 4)
                                
                                Text(item)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.jadeGreen.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.jadeGreen.opacity(0.3), lineWidth: 1)
                        )
                )
                
                // 忌
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 6) {
                        Image(systemName: "xmark.seal.fill")
                            .foregroundColor(.auspiciousRed)
                        Text("忌")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.auspiciousRed)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(advice.unsuitable.prefix(3), id: \.self) { item in
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(Color.auspiciousRed.opacity(0.6))
                                    .frame(width: 4, height: 4)
                                
                                Text(item)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.festiveAccent)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.luckyBorder, lineWidth: 1.5)
                        )
                )
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
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
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
                    icon: "star.fill",
                    title: "今日运势",
                    subtitle: "查看个人运势",
                    gradient: Color.festiveRedGradient
                ) {
                    // 跳转到运势页面
                }
                
                EnhancedQuickActionButton(
                    icon: "magnifyingglass",
                    title: "吉日查询",
                    subtitle: "寻找黄道吉日",
                    gradient: Color.luckyRedGradient
                ) {
                    // 跳转到吉日查询
                }
                
                EnhancedQuickActionButton(
                    icon: "bell.fill",
                    title: "提醒设置",
                    subtitle: "设置每日提醒",
                    gradient: Color.goldenGradient
                ) {
                    // 跳转到设置页面
                }
                
                EnhancedQuickActionButton(
                    icon: "gearshape.fill",
                    title: "应用设置",
                    subtitle: "个人信息设置",
                    gradient: Color.celebrationGradient
                ) {
                    // 跳转到设置页面
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
            // 顶部装饰条
            Rectangle()
                .fill(Color.festiveRedGradient)
                .frame(height: 3)
                .cornerRadius(1.5)
            
            // 月份导航头部
            HStack {
                Button(action: previousMonth) {
                    ZStack {
                        Circle()
                            .fill(Color.festiveRedGradient)
                            .frame(width: 36, height: 36)
                            .shadow(color: Color.cardShadow, radius: 4, x: 0, y: 2)
                        
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
                
                Text(monthYearString)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.luckyRedGradient)
                
                Spacer()
                
                Button(action: nextMonth) {
                    ZStack {
                        Circle()
                            .fill(Color.festiveRedGradient)
                            .frame(width: 36, height: 36)
                            .shadow(color: Color.cardShadow, radius: 4, x: 0, y: 2)
                        
                        Image(systemName: "chevron.right")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 4)
            
            // 星期标题
            HStack {
                ForEach(Array(weekdaySymbols.enumerated()), id: \.offset) { index, weekday in
                    Text(weekday)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(index == 0 || index == 6 ? .auspiciousRed : .secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 4)
            
            // 日期网格
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(daysInMonth, id: \.self) { date in
                    if let date = date {
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
                            .frame(height: 48)
                    }
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
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月"
        return formatter.string(from: displayedMonth)
    }
    
    private var weekdaySymbols: [String] {
        return ["日", "一", "二", "三", "四", "五", "六"]
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
            if calendar.isDate(date, equalTo: displayedMonth, toGranularity: .month) {
                days.append(date)
            } else {
                days.append(nil)
            }
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
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.system(size: 18, weight: isSelected ? .bold : .semibold))
                    .foregroundColor(textColor)
                
                // 农历日期、节日或休息日标识
                if isCurrentMonth {
                    if let displayInfo = getDisplayInfo() {
                        Text(displayInfo.text)
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(displayInfo.color)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                }
            }
            .frame(width: 48, height: 48)
            .background(backgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: isSelected ? 2 : (isToday ? 1.5 : 0))
            )
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowOffset)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        if !isCurrentMonth {
            return .gray.opacity(0.3)
        } else if isSelected {
            return .white
        } else if isToday {
            return .auspiciousRed
        } else if isWeekend {
            return .auspiciousRed
        } else {
            return .primary
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return Color.auspiciousRed
        } else if isToday {
            return Color.festiveAccent
        } else if isFestival {
            return Color.festiveAccent
        } else {
            return .clear
        }
    }
    
    private var borderColor: Color {
        if isSelected {
            return .auspiciousRed
        } else if isToday {
            return .luckyBorder
        } else {
            return .clear
        }
    }
    
    private var shadowColor: Color {
        if isSelected {
            return Color.auspiciousRed.opacity(0.4)
        } else if isToday {
            return Color.luckyBorder.opacity(0.3)
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
    
    private func getDisplayInfo() -> (text: String, color: Color)? {
        let calendarInfo = calendarService.getCalendarInfo(for: date)
        
        // 优先显示节日
        if let festival = calendarInfo.festival, !festival.isEmpty {
            let displayText = festival.count > 4 ? String(festival.prefix(4)) : festival
            return (displayText, .auspiciousRed)
        }
        
        // 显示节气
        if let solarTerm = calendarInfo.solarTerm, !solarTerm.isEmpty {
            return (solarTerm, .jadeGreen)
        }
        
        // 显示休息日标识
        if isWeekend {
            let weekday = Calendar.current.component(.weekday, from: date)
            if weekday == 1 {
                return ("休", .auspiciousRed.opacity(0.8))
            } else if weekday == 7 {
                return ("休", .auspiciousRed.opacity(0.8))
            }
        }
        
        // 显示农历日期
        let lunar = calendarInfo.lunarDate
        if lunar.day == "初一" {
            let monthText = lunar.month.count > 3 ? String(lunar.month.prefix(3)) : lunar.month
            return (monthText, .auspiciousRed.opacity(0.7))
        } else {
            let dayText = lunar.day.count > 3 ? String(lunar.day.prefix(3)) : lunar.day
            return (dayText, .secondary)
        }
    }
}

#Preview {
    HomeView()
} 