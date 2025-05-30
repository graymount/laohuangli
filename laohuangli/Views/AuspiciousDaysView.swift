import SwiftUI

struct AuspiciousDaysView: View {
    @StateObject private var calendarService = CalendarService.shared
    @StateObject private var userService = UserService.shared
    
    @State private var selectedEventType: EventType = .wedding
    @State private var startDate = Date()
    @State private var endDate = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
    @State private var auspiciousDays: [AuspiciousDay] = []
    @State private var isLoading = false
    @State private var showingEventTypePicker = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 查询条件区域
                SearchConditionsView(
                    selectedEventType: $selectedEventType,
                    startDate: $startDate,
                    endDate: $endDate,
                    onSearch: searchAuspiciousDays,
                    isLoading: isLoading
                )
                
                // 结果列表
                if isLoading {
                    LoadingView()
                } else if auspiciousDays.isEmpty {
                    EmptyResultView(eventType: selectedEventType)
                } else {
                    AuspiciousDaysListView(
                        auspiciousDays: auspiciousDays,
                        eventType: selectedEventType
                    )
                }
            }
            .navigationTitle("吉日查询")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.homeBackgroundGradient.ignoresSafeArea())
        }
        .onAppear {
            searchAuspiciousDays()
        }
    }
    
    private func searchAuspiciousDays() {
        isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let dateRange = startDate...endDate
            let results = calendarService.findAuspiciousDays(for: selectedEventType, in: dateRange)
            
            DispatchQueue.main.async {
                self.auspiciousDays = results
                self.isLoading = false
            }
        }
    }
}

// MARK: - 查询条件视图
struct SearchConditionsView: View {
    @Binding var selectedEventType: EventType
    @Binding var startDate: Date
    @Binding var endDate: Date
    let onSearch: () -> Void
    let isLoading: Bool
    
    @State private var showingEventTypePicker = false
    
    var body: some View {
        VStack(spacing: 16) {
            // 事件类型选择
            VStack(alignment: .leading, spacing: 12) {
                Text("选择事件类型")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Button(action: { showingEventTypePicker = true }) {
                    HStack {
                        Image(systemName: selectedEventType.icon)
                            .foregroundColor(.blue)
                        
                        Text(selectedEventType.rawValue)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .foregroundColor(.secondary)
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
            
            // 日期范围选择
            VStack(alignment: .leading, spacing: 12) {
                Text("选择日期范围")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("开始日期")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        DatePicker("开始日期", selection: $startDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("结束日期")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        DatePicker("结束日期", selection: $endDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                    }
                }
            }
            
            // 搜索按钮
            Button(action: onSearch) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: "magnifyingglass")
                    }
                    
                    Text(isLoading ? "查询中..." : "查找吉日")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }
            .disabled(isLoading)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackgroundGradient)
                .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.darkRedBorder, lineWidth: 1.5)
                )
        )
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .sheet(isPresented: $showingEventTypePicker) {
            EventTypePickerView(selectedEventType: $selectedEventType)
        }
    }
}

// MARK: - 事件类型选择器
struct EventTypePickerView: View {
    @Binding var selectedEventType: EventType
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(EventType.allCases, id: \.self) { eventType in
                    Button(action: {
                        selectedEventType = eventType
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: eventType.icon)
                                .foregroundColor(.blue)
                                .frame(width: 24)
                            
                            Text(eventType.rawValue)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if selectedEventType == eventType {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("选择事件类型")
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

// MARK: - 加载视图
struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text("正在查找吉日...")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.oldPaper)
    }
}

// MARK: - 空结果视图
struct EmptyResultView: View {
    let eventType: EventType
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            VStack(spacing: 8) {
                Text("未找到合适的吉日")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("在选定的日期范围内，没有找到适合\(eventType.rawValue)的黄道吉日。请尝试扩大日期范围或选择其他事件类型。")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.oldPaper)
    }
}

// MARK: - 吉日列表视图
struct AuspiciousDaysListView: View {
    let auspiciousDays: [AuspiciousDay]
    let eventType: EventType
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                // 结果统计
                HStack {
                    Text("找到 \(auspiciousDays.count) 个吉日")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("按吉凶程度排序")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                // 吉日卡片列表
                ForEach(auspiciousDays, id: \.date) { auspiciousDay in
                    AuspiciousDayCard(
                        auspiciousDay: auspiciousDay,
                        eventType: eventType
                    )
                }
                
                Spacer(minLength: 100)
            }
        }
        .background(Color(.systemGray6).opacity(0.3))
    }
}

// MARK: - 吉日卡片
struct AuspiciousDayCard: View {
    let auspiciousDay: AuspiciousDay
    let eventType: EventType
    
    @State private var showingDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 头部信息
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(formatDate(auspiciousDay.date))
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("\(auspiciousDay.lunarDate.month)\(auspiciousDay.lunarDate.day)")
                        .font(.body)
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack {
                        Text(auspiciousDay.rating.emoji)
                            .font(.title2)
                        Text(auspiciousDay.rating.rawValue)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: auspiciousDay.rating.color))
                    }
                    
                    FortuneRatingView(level: auspiciousDay.rating, size: .normal)
                }
            }
            
            // 适宜事项
            VStack(alignment: .leading, spacing: 8) {
                Text("适宜事项")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                    ForEach(auspiciousDay.suitableEvents.prefix(6), id: \.self) { event in
                        Text(event)
                            .font(.body)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.1))
                            .foregroundColor(.green)
                            .cornerRadius(8)
                    }
                }
            }
            
            // 描述
            Text(auspiciousDay.description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            // 操作按钮
            HStack {
                Button(action: { showingDetail = true }) {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("详情")
                    }
                    .font(.body)
                    .foregroundColor(.blue)
                }
                
                Spacer()
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackgroundGradient)
                .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.darkRedBorder, lineWidth: 1.5)
                )
        )
        .padding(.horizontal, 16)
        .sheet(isPresented: $showingDetail) {
            AuspiciousDayDetailView(auspiciousDay: auspiciousDay, eventType: eventType)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日 EEEE"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
}

// MARK: - 吉日详情视图
struct AuspiciousDayDetailView: View {
    let auspiciousDay: AuspiciousDay
    let eventType: EventType
    @Environment(\.dismiss) private var dismiss
    @State private var showingShareSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // 日期信息
                    DateInfoSection(auspiciousDay: auspiciousDay)
                    
                    // 吉凶评级
                    RatingSection(rating: auspiciousDay.rating)
                    
                    // 适宜事项
                    SuitableEventsSection(events: auspiciousDay.suitableEvents)
                    
                    // 详细说明
                    DescriptionSection(description: auspiciousDay.description, eventType: eventType)
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            .navigationTitle("吉日详情")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("关闭") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingShareSheet = true }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: [createShareText()])
        }
    }
    
    private func createShareText() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日 EEEE"
        formatter.locale = Locale(identifier: "zh_CN")
        let dateString = formatter.string(from: auspiciousDay.date)
        
        return """
        【\(eventType.rawValue)黄道吉日】
        
        日期：\(dateString)
        农历：\(auspiciousDay.lunarDate.month)\(auspiciousDay.lunarDate.day)
        吉凶：\(auspiciousDay.rating.rawValue) \(auspiciousDay.rating.emoji)
        
        适宜：\(auspiciousDay.suitableEvents.joined(separator: "、"))
        
        \(auspiciousDay.description)
        
        ——来自老黄历App
        """
    }
}

// MARK: - 详情页面组件
struct DateInfoSection: View {
    let auspiciousDay: AuspiciousDay
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("日期信息")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(formatDate(auspiciousDay.date))
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("公历")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(auspiciousDay.lunarDate.month)\(auspiciousDay.lunarDate.day)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    
                    Text("农历")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日 EEEE"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
}

struct RatingSection: View {
    let rating: FortuneLevel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("吉凶评级")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack {
                Text(rating.emoji)
                    .font(.system(size: 40))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(rating.rawValue)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: rating.color))
                    
                    FortuneRatingView(level: rating)
                }
                
                Spacer()
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
}

struct SuitableEventsSection: View {
    let events: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("适宜事项")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(events, id: \.self) { event in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        
                        Text(event)
                            .font(.subheadline)
                        
                        Spacer()
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.green.opacity(0.1))
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackgroundGradient)
                .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.darkRedBorder, lineWidth: 1.5)
                )
        )
    }
}

struct DescriptionSection: View {
    let description: String
    let eventType: EventType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("详细说明")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(nil)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackgroundGradient)
                .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.darkRedBorder, lineWidth: 1.5)
                )
        )
    }
}

#Preview {
    AuspiciousDaysView()
} 